import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/mock/mock_data.dart';
import 'package:vitis/data/mock/mock_parsers.dart';
import 'package:vitis/data/parsers/transfer_parser.dart';
import 'package:vitis/data/repositories/movement_repository.dart';
import 'package:vitis/data/repositories/saving_repository.dart';
import 'package:vitis/data/repositories/user_repository.dart';
import 'package:vitis/data/repositories/wallet_repository.dart';
import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/saving.dart';
import 'package:vitis/data/models/wallet.dart';

void main() {
  group('MockUserRepository', () {
    late MockUserRepository users;

    setUp(() => users = MockUserRepository());

    test('logs in the demo account, ignoring email case', () async {
      final user = await users.login(' DEMO@vitis.app ', demoPassword);

      expect(user?.id, demoUserId);
    });

    test('rejects a wrong password and an unknown email', () async {
      expect(await users.login(demoEmail, 'wrong'), isNull);
      expect(await users.login('nobody@x.com', demoPassword), isNull);
    });

    test('never stores the plain password', () async {
      final user = await users.register(
        name: 'Ana',
        email: 'ana@x.com',
        password: 'secret123',
      );

      expect(user!.password, isNot(contains('secret123')));
      expect((await users.login('ana@x.com', 'secret123'))?.id, user.id);
    });

    test('rejects a registered email, ignoring case', () async {
      final user = await users.register(
        name: 'Otra',
        email: 'DEMO@VITIS.APP',
        password: 'secret123',
      );

      expect(user, isNull);
    });

    test('update rejects the email of another account', () async {
      final ana = await users.register(
        name: 'Ana',
        email: 'ana@x.com',
        password: 'secret123',
      );

      expect(await users.update(ana!.copyWith(email: demoEmail)), isFalse);
      expect(await users.update(ana.copyWith(name: 'Ana María')), isTrue);
    });

    test('changePassword replaces the old password', () async {
      await users.changePassword(demoUserId, 'newpass123');

      expect(await users.login(demoEmail, demoPassword), isNull);
      expect((await users.login(demoEmail, 'newpass123'))?.id, demoUserId);
    });
  });

  test('each user only gets their own data', () async {
    final wallets = MockWalletRepository();
    final savings = MockSavingRepository();
    final movements = MockMovementRepository();
    const wallet = Wallet(
      userId: 'ana',
      name: 'MP',
      logo: '',
      providerKey: 'mp',
      balance: 0,
    );
    const saving = Saving(
      userId: 'ana',
      name: 'Viaje',
      reserved: 0,
      target: 1,
      icon: 'barrel',
    );
    final cash = Cash(
      userId: 'ana',
      amount: 1,
      type: MovementType.income,
      date: DateTime.now(),
    );

    await wallets.add(wallet);
    await savings.add(saving);
    await movements.addCash(cash);

    expect(await wallets.listForUser('ana'), hasLength(1));
    expect(await savings.listForUser('ana'), hasLength(1));
    expect(await movements.cashForUser('ana'), hasLength(1));
    expect(await wallets.listForUser('beto'), isEmpty);
    expect(await savings.listForUser('beto'), isEmpty);
    expect(await movements.cashForUser('beto'), isEmpty);
  });

  test('new records get different ids', () async {
    final wallets = MockWalletRepository();
    const wallet = Wallet(
      userId: 'ana',
      name: 'MP',
      logo: '',
      providerKey: 'mp',
      balance: 0,
    );

    final a = await wallets.add(wallet);
    final b = await wallets.add(wallet);

    expect(a.id, isNotNull);
    expect(a.id, isNot(b.id));
  });

  test('mock parsers reject a malformed response', () {
    registerMockParsers();

    for (final provider in ['mp', 'nx']) {
      expect(
        () => parsersByProvider[provider]!.parse({'data': <String, Object?>{}}),
        throwsFormatException,
      );
    }
  });

  test('demo transfers go through every mock parser', () {
    final transfers = demoTransfers();

    expect(transfers.map((t) => t.walletId).toSet(), hasLength(6));
    expect(transfers.every((t) => t.title.isNotEmpty), isTrue);
    // Sin categoría en el response: cae en la categoría por defecto.
    expect(transfers.where((t) => t.category == 'Otros'), hasLength(2));
  });
}
