import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/movement.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/saving.dart';
import 'package:vitis/data/models/transfer.dart';
import 'package:vitis/data/models/user.dart';
import 'package:vitis/data/models/wallet.dart';

void main() {
  final date = DateTime.utc(2026, 8, 26, 12, 30);

  test('User round trip, with preferences', () {
    const user = User(
      name: 'Ana',
      email: 'ana@x.com',
      password: r'pbkdf2$1$a$b',
      preferences: [Preference(key: 'theme', value: 'dark')],
    );

    final copy = User.fromMap('u1', user.toMap());

    expect(copy.id, 'u1');
    expect(copy.name, 'Ana');
    expect(copy.email, 'ana@x.com');
    expect(copy.password, r'pbkdf2$1$a$b');
    expect(copy.preferences.single.key, 'theme');
    expect(copy.preferences.single.value, 'dark');
  });

  test('User gives the first name and the initial for the UI', () {
    const user = User(
      name: '  maría gonzález',
      email: 'a@x.com',
      password: 'h',
    );

    expect(user.firstName, 'maría');
    expect(user.initial, 'M');
    expect(User.initialOf('   '), '?');
  });

  test('Saving progress is clamped and remaining is never negative', () {
    const over = Saving(
      userId: 'u1',
      name: 'Trip',
      reserved: 150,
      target: 100,
      icon: 'barrel',
    );
    const noTarget = Saving(
      userId: 'u1',
      name: 'Trip',
      reserved: 10,
      target: 0,
      icon: 'barrel',
    );

    expect(over.progress, 1);
    expect(over.percent, 100);
    expect(over.remaining, 0);
    expect(noTarget.progress, 0);
  });

  test('User stores the normalized email', () {
    const user = User(name: 'A', email: ' Ana@X.com ', password: 'h');

    expect(user.toMap()['email'], 'ana@x.com');
  });

  test('withPreference replaces a key instead of repeating it', () {
    const user = User(name: 'Ana', email: 'a@x.com', password: 'h');

    final updated = user
        .withPreference(Preference.currency, 'USD')
        .withPreference(Preference.pin, 'true')
        .withPreference(Preference.currency, 'ARS');

    expect(updated.preferences, hasLength(2));
    expect(updated.currency, 'ARS');
    expect(updated.pinEnabled, isTrue);
    expect(user.preferences, isEmpty);
  });

  test('a user without preferences gets the defaults', () {
    const user = User(name: 'Ana', email: 'a@x.com', password: 'h');

    expect(user.notificationsEnabled, isFalse);
    expect(user.pinEnabled, isFalse);
    expect(user.currency, 'ARS');
    expect(user.preference(Preference.theme), isNull);
  });

  test('User without preferences', () {
    const user = User(name: 'Ana', email: 'a@x.com', password: 'h');

    expect(User.fromMap('u1', user.toMap()).preferences, isEmpty);
  });

  test('Movement of a disconnected wallet stays out of the balance', () {
    final transfer = Transfer(
      userId: 'ana',
      walletId: 'w1',
      response: const {},
      title: 'Kiosco',
      amount: 10,
      type: MovementType.expense,
      date: DateTime.utc(2026),
      category: 'Otros',
    );
    const wallet = Wallet(
      id: 'w1',
      userId: 'ana',
      name: 'MP',
      logo: '',
      providerKey: 'mp',
      balance: 0,
      status: WalletStatus.disconnected,
    );

    final movement = Movement.fromTransfer(transfer, wallet);

    expect(movement.source, 'MP');
    expect(movement.countsInBalance, isFalse);
  });

  test('Wallet round trip, without credentials in the document', () {
    const wallet = Wallet(
      userId: 'u1',
      name: 'Bank',
      logo: 'b.png',
      providerKey: 'mp',
      balance: 100,
    );

    final map = wallet.toMap();
    final copy = Wallet.fromMap('w1', map);

    expect(
      map.keys,
      unorderedEquals([
        'userId',
        'name',
        'logo',
        'providerKey',
        'balance',
        'status',
      ]),
    );
    expect(copy.id, 'w1');
    expect(copy.userId, 'u1');
    expect(copy.name, 'Bank');
    expect(copy.logo, 'b.png');
    expect(copy.providerKey, 'mp');
    expect(copy.balance, 100.0);
    expect(copy.status, WalletStatus.pending);
  });

  test('Cash round trip', () {
    final cash = Cash(
      userId: 'u1',
      amount: 150.5,
      type: MovementType.expense,
      date: date,
      note: 'Coffee',
    );

    final copy = Cash.fromMap('c1', cash.toMap());

    expect(copy.id, 'c1');
    expect(copy.userId, 'u1');
    expect(copy.amount, 150.5);
    expect(copy.type, MovementType.expense);
    expect(copy.date, date);
    expect(copy.note, 'Coffee');
  });

  test('Cash without a note', () {
    final cash = Cash(
      userId: 'u1',
      amount: 1,
      type: MovementType.income,
      date: date,
    );

    expect(Cash.fromMap('c1', cash.toMap()).note, isNull);
  });

  test('an amount coming back from the database as int reads as double', () {
    final cash = Cash.fromMap('c1', {
      'userId': 'u1',
      'amount': 150,
      'type': 'income',
      'date': date.toIso8601String(),
    });
    final saving = Saving.fromMap('s1', {
      'userId': 'u1',
      'name': 'Trip',
      'reserved': 45000,
      'target': 150000,
      'icon': 'barrel',
    });

    expect(cash.amount, 150.0);
    expect(saving.reserved, 45000.0);
    expect(saving.target, 150000.0);
  });

  test('local dates are stored in UTC and stay the same instant', () {
    final local = DateTime(2026, 8, 26, 12, 30);
    final cash = Cash(
      userId: 'u1',
      amount: 1,
      type: MovementType.income,
      date: local,
    );

    final map = cash.toMap();

    expect(map['date'] as String, endsWith('Z'));
    expect(Cash.fromMap('c1', map).date.isAtSameMomentAs(local), isTrue);
  });

  test('Saving round trip', () {
    const saving = Saving(
      userId: 'u1',
      name: 'Trip',
      reserved: 45000.5,
      target: 150000,
      icon: 'barrel',
    );

    final copy = Saving.fromMap('s1', saving.toMap());

    expect(copy.id, 's1');
    expect(copy.userId, 'u1');
    expect(copy.name, 'Trip');
    expect(copy.reserved, 45000.5);
    expect(copy.target, 150000);
    expect(copy.icon, 'barrel');
  });

  test('Transfer round trip keeps the nested response', () {
    final transfer = Transfer(
      userId: 'u1',
      walletId: 'w1',
      response: {
        'data': {
          'value': '10.00',
          'tags': ['a', 'b'],
        },
      },
      title: 'Sueldo',
      amount: 10,
      type: MovementType.income,
      date: date,
      category: 'Other',
    );

    final copy = Transfer.fromMap('t1', transfer.toMap());

    expect(copy.id, 't1');
    expect(copy.userId, 'u1');
    expect(copy.walletId, 'w1');
    expect(copy.response, transfer.response);
    expect(copy.title, 'Sueldo');
    expect(copy.amount, 10.0);
    expect(copy.type, MovementType.income);
    expect(copy.date, date);
    expect(copy.category, 'Other');
  });
}
