import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/mock/mock_data.dart';
import 'package:vitis/data/models/user.dart';
import 'package:vitis/data/models/wallet.dart';
import 'package:vitis/data/repositories/movement_repository.dart';
import 'package:vitis/data/repositories/saving_repository.dart';
import 'package:vitis/data/repositories/user_repository.dart';
import 'package:vitis/data/repositories/wallet_repository.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/data/states/savings_store.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/data/states/wallets_store.dart';

void main() {
  late WalletsStore wallets;
  late SavingsStore savings;
  late MovementsStore movements;
  late SessionStore session;

  setUp(() {
    final walletRepository = MockWalletRepository(demoWallets());
    wallets = WalletsStore(walletRepository);
    savings = SavingsStore(MockSavingRepository(demoSavings()));
    movements = MovementsStore(
      MockMovementRepository(cash: demoCash(), transfers: demoTransfers()),
      walletRepository,
    );
    session = SessionStore(MockUserRepository(), wallets, savings, movements);
  });

  test('login loads the data of the user', () async {
    expect(await session.login(demoEmail, demoPassword), isTrue);

    expect(session.currentUser?.firstName, 'María');
    expect(wallets.wallets, hasLength(4));
    expect(savings.savings, hasLength(2));
    expect(movements.movements, isNotEmpty);
  });

  test('demo available balance is wallets plus cash minus savings', () async {
    await session.login(demoEmail, demoPassword);

    expect(session.availableBalance, 930401.25);
    expect(savings.totalReserved, 125000);
  });

  test('demo growth stays modest on any day of the month', () async {
    for (final (email, password) in [
      (demoEmail, demoPassword),
      (secondDemoEmail, secondDemoPassword),
    ]) {
      await session.login(email, password);
      final balance = session.balance;
      final now = DateTime.now();

      // Las fechas son relativas a hoy: cada corte simula un día del mes.
      for (var day = 1; day <= 31; day++) {
        final monthStart = DateTime(now.year, now.month, now.day - day + 1);
        final net = movements.movements
            .where((m) => !m.date.isBefore(monthStart))
            .fold(0.0, (sum, m) => sum + m.signedAmount);

        expect(net / (balance - net) * 100, inInclusiveRange(-12, 12));
      }
      session.logout();
    }
  });

  test('the second demo account sees only its own data', () async {
    expect(await session.login(secondDemoEmail, secondDemoPassword), isTrue);

    expect(session.currentUser?.firstName, 'Tomás');
    expect(wallets.wallets, hasLength(2));
    expect(savings.savings.single.name, 'Moto nueva');
    expect(movements.movements.map((m) => m.title), contains('Spotify'));
    expect(movements.movements.map((m) => m.title), isNot(contains('Netflix')));
  });

  group('disconnectWallet', () {
    setUp(() => session.login(demoEmail, demoPassword));

    Wallet walletNamed(String name) =>
        wallets.wallets.firstWhere((w) => w.name == name);

    test('takes its balance out and keeps its movements', () async {
      final before = movements.movements.length;
      final available = session.availableBalance;

      expect(await session.disconnectWallet(walletNamed('LemonCash')), isTrue);

      expect(wallets.wallets, hasLength(3));
      expect(session.availableBalance, available - 7320.75);
      expect(movements.movements, hasLength(before));
      final kept = movements.movements.firstWhere((m) => m.title == 'Kiosco');
      expect(kept.source, 'LemonCash');
      expect(kept.countsInBalance, isFalse);
    });

    test('is refused if the savings would lose their backing', () async {
      await savings.add(name: 'Casa', reserved: 900000, target: 1000000);

      final refused = await session.disconnectWallet(
        walletNamed('Banco Nación'),
      );

      expect(refused, isFalse);
      expect(wallets.wallets, hasLength(4));
      expect(session.availableBalance, greaterThanOrEqualTo(0));
    });
  });

  group('preferences', () {
    test('belong to the user and survive a new login', () async {
      await session.login(demoEmail, demoPassword);
      await session.setPreference(Preference.currency, 'USD');
      await session.setPreference(Preference.theme, ThemeMode.dark.name);
      expect(session.themeMode, ThemeMode.dark);
      session.logout();

      await session.login(secondDemoEmail, secondDemoPassword);
      expect(session.currentUser?.currency, 'ARS');
      expect(session.themeMode, ThemeMode.system);
      session.logout();

      await session.login(demoEmail, demoPassword);
      expect(session.currentUser?.currency, 'USD');
      expect(session.themeMode, ThemeMode.dark);
    });

    test('the theme goes back to the device one on logout', () async {
      await session.login(demoEmail, demoPassword);
      await session.setPreference(Preference.theme, ThemeMode.dark.name);

      session.logout();

      expect(session.themeMode, ThemeMode.system);
    });

    test('an unknown saved theme falls back to the device one', () async {
      await session.login(demoEmail, demoPassword);
      await session.setPreference(Preference.theme, 'purple');

      expect(session.themeMode, ThemeMode.system);
    });

    test('notify the listeners', () async {
      await session.login(demoEmail, demoPassword);
      var notified = 0;
      session.addListener(() => notified++);

      await session.setPreference(Preference.pin, 'true');

      expect(notified, 1);
    });

    test('are kept when the profile is edited', () async {
      await session.login(demoEmail, demoPassword);
      await session.setPreference(Preference.currency, 'USD');

      await session.updateProfile(name: 'Maru');
      session.logout();
      await session.login(demoEmail, demoPassword);

      expect(session.currentUser?.name, 'Maru');
      expect(session.currentUser?.currency, 'USD');
    });
  });

  test('saving after a password change does not restore the old one', () async {
    await session.login(demoEmail, demoPassword);
    await session.changePassword('newpass123');

    await session.setPreference(Preference.pin, 'true');
    await session.updateProfile(name: 'Maru');
    session.logout();

    expect(await session.login(demoEmail, demoPassword), isFalse);
    expect(await session.login(demoEmail, 'newpass123'), isTrue);
  });

  test('a failed login starts no session and loads nothing', () async {
    expect(await session.login(demoEmail, 'wrong'), isFalse);

    expect(session.currentUser, isNull);
    expect(wallets.wallets, isEmpty);
  });

  test('logout empties every store', () async {
    await session.login(demoEmail, demoPassword);

    session.logout();

    expect(session.currentUser, isNull);
    expect(wallets.wallets, isEmpty);
    expect(savings.savings, isEmpty);
    expect(movements.movements, isEmpty);
    expect(movements.netCash, 0);
  });

  test('a new account does not see data of the previous user', () async {
    await session.login(demoEmail, demoPassword);
    session.logout();

    expect(
      await session.register(
        name: 'Ana',
        email: 'ana@x.com',
        password: 'secret123',
      ),
      isTrue,
    );
    await session.login('ana@x.com', 'secret123');

    expect(session.currentUser?.name, 'Ana');
    expect(wallets.wallets, isEmpty);
    expect(savings.savings, isEmpty);
    expect(movements.movements, isEmpty);
  });

  test('register does not start the session', () async {
    await session.register(
      name: 'Ana',
      email: 'a@x.com',
      password: 'secret123',
    );

    expect(session.currentUser, isNull);
  });

  test(
    'updateProfile changes only what it gets and rejects a used email',
    () async {
      await session.register(
        name: 'Ana',
        email: 'a@x.com',
        password: 'secret123',
      );
      await session.login(demoEmail, demoPassword);

      expect(await session.updateProfile(name: 'Maru'), isTrue);
      expect(session.currentUser?.name, 'Maru');
      expect(session.currentUser?.email, demoEmail);

      expect(await session.updateProfile(email: ' A@X.com'), isFalse);
      expect(session.currentUser?.email, demoEmail);
    },
  );

  test('changePassword lets the user log in with the new one', () async {
    await session.login(demoEmail, demoPassword);

    await session.changePassword('newpass123');
    session.logout();

    expect(await session.login(demoEmail, demoPassword), isFalse);
    expect(await session.login(demoEmail, 'newpass123'), isTrue);
  });
}
