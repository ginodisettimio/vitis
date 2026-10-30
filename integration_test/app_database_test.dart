import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:vitis/data/db/app_database.dart';
import 'package:vitis/data/states/document_store.dart';
import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/user.dart';

// Contra Couchbase real, en una carpeta temporal: no toca la base de la app.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase.instance;
  late Directory directory;

  setUpAll(() async {
    directory = await Directory.systemTemp.createTemp('vitis_test');
    await db.open(
      opener: () => CouchbaseStore.open(
        'vitis_test',
        AppDatabase.collections,
        directory: directory.path,
      ),
    );
  });

  tearDownAll(() async {
    await db.close();
    await directory.delete(recursive: true);
  });

  Cash cashOf(String userId, double amount) => Cash(
    userId: userId,
    amount: amount,
    type: MovementType.income,
    date: DateTime.utc(2026, 8, 26),
  );

  test('each user sees only their own documents', () async {
    await db.save(AppDatabase.cash, cashOf('ana', 10).toMap());
    await db.save(AppDatabase.cash, cashOf('ana', 20).toMap());
    await db.save(AppDatabase.cash, cashOf('beto', 30).toMap());

    final ofAna = await db.listForUser(AppDatabase.cash, 'ana');
    final ofBeto = await db.listForUser(AppDatabase.cash, 'beto');

    final anaAmounts = ofAna
        .map((m) => Cash.fromMap(m['id'] as String, m).amount)
        .toList();
    expect(anaAmounts, unorderedEquals([10.0, 20.0]));
    expect(ofBeto.single['amount'], 30);
  });

  test('an injection in the user does not return other users data', () async {
    await db.save(AppDatabase.cash, cashOf('carla', 1).toMap());

    final result = await db.listForUser(AppDatabase.cash, "x' OR '1'='1");

    expect(result, isEmpty);
  });

  test('finds the account by email, case-insensitively', () async {
    const ana = User(name: 'Ana', email: 'Ana@X.com', password: 'h1');
    const beto = User(name: 'Beto', email: 'beto@x.com', password: 'h2');
    final anaId = await db.save(AppDatabase.users, ana.toMap());
    await db.save(AppDatabase.users, beto.toMap());

    final found = await db.findUserByEmail(' ana@x.COM ');

    expect(found?['id'], anaId);
    expect(User.fromMap(anaId, found!).name, 'Ana');
    expect(await db.findUserByEmail('nobody@x.com'), isNull);
  });

  test('save, replace, get and delete by id', () async {
    final id = await db.save(AppDatabase.savings, {
      'userId': 'ana',
      'name': 'Trip',
      'detail': {
        'tags': ['a', 'b'],
      },
    });
    await db.save(AppDatabase.savings, {
      'userId': 'ana',
      'name': 'House',
    }, id: id);

    final found = await db.get(AppDatabase.savings, id);
    expect(found?['name'], 'House');
    expect(found?['id'], id);

    await db.delete(AppDatabase.savings, id);
    expect(await db.get(AppDatabase.savings, id), isNull);
    await db.delete(AppDatabase.savings, id); // borrar dos veces no falla
  });

  test('a nested response comes back as it was saved', () async {
    final response = {
      'data': {
        'value': '10.00',
        'tags': ['a', 'b'],
        'extra': {'n': 1},
      },
    };
    final id = await db.save(AppDatabase.transfers, {'response': response});

    final found = await db.get(AppDatabase.transfers, id);

    expect(found?['response'], response);
  });
}
