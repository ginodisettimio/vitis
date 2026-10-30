import 'package:vitis/data/models/wallet.dart';

abstract interface class WalletRepository {
  Future<List<Wallet>> listForUser(String userId);

  // Devuelve la billetera con su id asignado.
  Future<Wallet> add(Wallet wallet);

  Future<void> update(Wallet wallet);
}

class MockWalletRepository implements WalletRepository {
  MockWalletRepository([List<Wallet> seed = const []])
    : _wallets = List.of(seed);

  final List<Wallet> _wallets;
  int _nextId = 1;

  @override
  Future<List<Wallet>> listForUser(String userId) async =>
      _wallets.where((wallet) => wallet.userId == userId).toList();

  @override
  Future<Wallet> add(Wallet wallet) async {
    final saved = wallet.copyWith(id: 'wallet-${_nextId++}');
    _wallets.add(saved);
    return saved;
  }

  @override
  Future<void> update(Wallet wallet) async {
    _wallets[_wallets.indexWhere((w) => w.id == wallet.id)] = wallet;
  }
}
