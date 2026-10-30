import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:vitis/data/db/app_database.dart';
import 'package:vitis/data/states/document_store.dart';

class MockStore extends Mock implements DocumentStore {}

void main() {
  final db = AppDatabase.instance;
  late MockStore store;

  setUp(() {
    store = MockStore();
    when(() => store.close()).thenAnswer((_) async {});
  });

  tearDown(() => db.close());

  test('instance is always the same object', () {
    expect(identical(AppDatabase.instance, AppDatabase.instance), isTrue);
  });

  test('throws StateError when not open', () {
    expect(() => db.get(AppDatabase.users, 'u1'), throwsStateError);
    expect(() => db.findUserByEmail('a@x.com'), throwsStateError);
  });

  test('concurrent open calls open only once', () async {
    var openings = 0;
    Future<DocumentStore> opener() async {
      openings++;
      return store;
    }

    await Future.wait([db.open(opener: opener), db.open(opener: opener)]);

    expect(openings, 1);
  });

  test('open can be retried after a failure', () async {
    await expectLater(
      db.open(opener: () async => throw Exception('no disk')),
      throwsException,
    );

    await db.open(opener: () async => store);
    when(() => store.get('users', 'u1')).thenAnswer((_) async => null);

    expect(await db.get(AppDatabase.users, 'u1'), isNull);
  });

  test('close closes the store and stops accepting operations', () async {
    await db.open(opener: () async => store);

    await db.close();

    verify(() => store.close()).called(1);
    expect(() => db.get(AppDatabase.users, 'u1'), throwsStateError);
  });

  group('with the database open', () {
    setUp(() => db.open(opener: () async => store));

    test('save delegates and returns the id', () async {
      when(() => store.save('savings', {'name': 'Trip'}, id: null))
          .thenAnswer((_) async => 's1');

      expect(await db.save(AppDatabase.savings, {'name': 'Trip'}), 's1');
    });

    test('save with an id passes it to replace the document', () async {
      when(() => store.save('savings', {'name': 'Trip'}, id: 's1'))
          .thenAnswer((_) async => 's1');

      await db.save(AppDatabase.savings, {'name': 'Trip'}, id: 's1');

      verify(() => store.save('savings', {'name': 'Trip'}, id: 's1')).called(1);
    });

    test('get delegates', () async {
      when(() => store.get('wallets', 'w1'))
          .thenAnswer((_) async => {'id': 'w1', 'name': 'Bank'});

      expect(await db.get(AppDatabase.wallets, 'w1'), {
        'id': 'w1',
        'name': 'Bank',
      });
    });

    test('delete delegates', () async {
      when(() => store.delete('cash', 'c1')).thenAnswer((_) async {});

      await db.delete(AppDatabase.cash, 'c1');

      verify(() => store.delete('cash', 'c1')).called(1);
    });

    test('rejects unknown collections without touching the store', () {
      expect(() => db.get('x; DROP', 'id'), throwsArgumentError);
      expect(() => db.save('x', {}), throwsArgumentError);
      expect(() => db.delete('x', 'id'), throwsArgumentError);
      expect(() => db.listForUser('x', 'u1'), throwsArgumentError);
      verifyNever(() => store.query(any(), any()));
    });

    test(
      'listForUser passes the user as a parameter, not in the SQL',
      () async {
        const malicious = "u1' OR '1'='1";
        when(() => store.query(any(), any())).thenAnswer((_) async => []);

        await db.listForUser(AppDatabase.cash, malicious);

        final captured = verify(() => store.query(captureAny(), captureAny()))
            .captured;
        expect(captured[0], contains(r'c.userId = $userId'));
        expect(captured[0], contains('FROM cash'));
        expect(captured[0], isNot(contains(malicious)));
        expect(captured[1], {'userId': malicious});
      },
    );

    test('listForUser flattens documents and includes the id', () async {
      when(() => store.query(any(), any())).thenAnswer(
        (_) async => [
          {
            'id': 'c1',
            'doc': {'userId': 'u1', 'amount': 10},
          },
        ],
      );

      expect(await db.listForUser(AppDatabase.cash, 'u1'), [
        {'id': 'c1', 'userId': 'u1', 'amount': 10},
      ]);
    });

    test('findUserByEmail normalizes the email and parameterizes it', () async {
      when(() => store.query(any(), any())).thenAnswer(
        (_) async => [
          {
            'id': 'u1',
            'doc': {'email': 'ana@x.com'},
          },
        ],
      );

      final user = await db.findUserByEmail('  ANA@x.com ');

      expect(user, {'id': 'u1', 'email': 'ana@x.com'});
      final captured = verify(() => store.query(captureAny(), captureAny()))
          .captured;
      expect(captured[0], isNot(contains('ana@x.com')));
      expect(captured[1], {'email': 'ana@x.com'});
    });

    test('findUserByEmail returns null when it does not exist', () async {
      when(() => store.query(any(), any())).thenAnswer((_) async => []);

      expect(await db.findUserByEmail('nobody@x.com'), isNull);
    });
  });
}
