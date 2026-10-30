import 'package:flutter/foundation.dart';
import 'package:vitis/data/repositories/repositories.dart';
import 'package:vitis/data/repositories/wallet_repository.dart';
import 'package:vitis/data/models/wallet.dart';

// Billeteras del usuario actual. Las pantallas la escuchan con ListenableBuilder.
class WalletsStore extends ChangeNotifier {
  WalletsStore(this._repository);

  static final WalletsStore instance = WalletsStore(walletRepository);

  final WalletRepository _repository;
  String? _userId;
  List<Wallet> _wallets = [];

  // Sin las desconectadas: ni se muestran ni suman al saldo.
  List<Wallet> get wallets => List.unmodifiable(_wallets);

  int get connectedCount =>
      _wallets.where((w) => w.status == WalletStatus.connected).length;

  double get totalBalance =>
      _wallets.fold(0, (sum, wallet) => sum + wallet.balance);

  Future<void> load(String userId) async {
    _userId = userId;
    _wallets = (await _repository.listForUser(userId))
        .where((w) => w.status != WalletStatus.disconnected)
        .toList();
    notifyListeners();
  }

  void clear() {
    _userId = null;
    _wallets = [];
    notifyListeners();
  }

  // Una billetera nueva arranca en 0 hasta que se sincronice con su banco.
  Future<void> add({required String name, required String providerKey}) async {
    final saved = await _repository.add(
      Wallet(
        userId: _userId!,
        name: name,
        logo: '',
        providerKey: providerKey,
        balance: 0,
      ),
    );
    _wallets = [..._wallets, saved];
    notifyListeners();
  }

  Future<void> disconnect(Wallet wallet) async {
    await _repository.update(
      wallet.copyWith(status: WalletStatus.disconnected),
    );
    _wallets = _wallets.where((w) => w.id != wallet.id).toList();
    notifyListeners();
  }
}
