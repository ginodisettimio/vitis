import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/repositories/wallet_repository.dart';
import 'package:vitis/data/models/wallet.dart';
import 'package:vitis/data/states/wallets_store.dart';

void main() {
  const wallet = Wallet(
    id: 'w1',
    userId: 'ana',
    name: 'MP',
    logo: '',
    providerKey: 'mp',
    balance: 100.5,
  );

  test('load gives the user wallets and their total', () async {
    final store = WalletsStore(MockWalletRepository([wallet]));

    await store.load('ana');

    expect(store.wallets.single.name, 'MP');
    expect(store.totalBalance, 100.5);
  });

  test('add stores the wallet for the user, at 0, and notifies', () async {
    final repository = MockWalletRepository();
    final store = WalletsStore(repository);
    var notified = 0;
    store.addListener(() => notified++);
    await store.load('ana');

    await store.add(name: 'Mi Lemon', providerKey: 'lm');

    expect(store.wallets.single.providerKey, 'lm');
    expect(store.wallets.single.balance, 0);
    expect(store.wallets.single.status, WalletStatus.pending);
    expect(store.connectedCount, 0);
    expect((await repository.listForUser('ana')).single.name, 'Mi Lemon');
    expect(notified, 2);
  });

  test('disconnect hides the wallet, also after a reload', () async {
    final repository = MockWalletRepository([wallet]);
    final store = WalletsStore(repository);
    await store.load('ana');

    await store.disconnect(wallet);

    expect(store.wallets, isEmpty);
    expect(store.totalBalance, 0);
    await store.load('ana');
    expect(store.wallets, isEmpty);
    expect(
      (await repository.listForUser('ana')).single.status,
      WalletStatus.disconnected,
    );
  });

  test('clear removes the data', () async {
    final store = WalletsStore(MockWalletRepository([wallet]));
    await store.load('ana');

    store.clear();

    expect(store.wallets, isEmpty);
    expect(store.totalBalance, 0);
  });
}
