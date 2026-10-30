import 'package:flutter/foundation.dart';
import 'package:vitis/data/repositories/movement_repository.dart';
import 'package:vitis/data/repositories/repositories.dart';
import 'package:vitis/data/repositories/wallet_repository.dart';
import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/category_spending.dart';
import 'package:vitis/data/models/movement.dart';
import 'package:vitis/data/models/movement_type.dart';

// Efectivo y transferencias del usuario actual, y lo que se calcula con ellos.
class MovementsStore extends ChangeNotifier {
  MovementsStore(this._repository, this._wallets);

  static final MovementsStore instance = MovementsStore(
    movementRepository,
    walletRepository,
  );

  static const int _recentCount = 6;

  final MovementRepository _repository;
  final WalletRepository
  _wallets; // para saber de qué billetera salió cada transferencia
  String? _userId;
  List<Movement> _movements = [];
  double _netCash = 0;

  // Del más reciente al más antiguo.
  List<Movement> get movements => List.unmodifiable(_movements);

  List<Movement> get recent => movements.take(_recentCount).toList();

  // Ingresos menos egresos en efectivo. Las transferencias no cuentan porque ya
  // están en el saldo que informa el banco.
  double get netCash => _netCash;

  Future<void> load(String userId) async {
    _userId = userId;
    final cash = await _repository.cashForUser(userId);
    final transfers = await _repository.transfersForUser(userId);
    final wallets = {
      for (final wallet in await _wallets.listForUser(userId))
        wallet.id: wallet,
    };

    _movements = [
      ...cash.map(Movement.fromCash),
      ...transfers.map((t) => Movement.fromTransfer(t, wallets[t.walletId])),
    ]..sort((a, b) => b.date.compareTo(a.date));
    _netCash = cash.fold(0.0, (sum, c) => sum + _signed(c));
    notifyListeners();
  }

  void clear() {
    _userId = null;
    _movements = [];
    _netCash = 0;
    notifyListeners();
  }

  Future<void> addCash({
    required double amount,
    required MovementType type,
    String? note,
  }) async {
    final saved = await _repository.addCash(
      Cash(
        userId: _userId!,
        amount: amount,
        type: type,
        date: DateTime.now(),
        note: note,
      ),
    );
    _movements = [Movement.fromCash(saved), ..._movements]
      ..sort((a, b) => b.date.compareTo(a.date));
    _netCash += _signed(saved);
    notifyListeners();
  }

  double _signed(Cash cash) =>
      cash.type == MovementType.income ? cash.amount : -cash.amount;

  Iterable<Movement> get _thisMonth {
    final now = DateTime.now();
    return _movements.where(
      (m) => m.date.year == now.year && m.date.month == now.month,
    );
  }

  double get totalExpenses => _thisMonth
      .where((m) => !m.isIncome)
      .fold(0.0, (sum, m) => sum - m.signedAmount);

  // Gastos del mes por categoría, de mayor a menor.
  List<CategorySpending> get expensesByCategory {
    final total = totalExpenses;
    final amounts = <String, double>{};
    for (final movement in _thisMonth.where((m) => !m.isIncome)) {
      amounts[movement.category] =
          (amounts[movement.category] ?? 0) - movement.signedAmount;
    }
    return [
      for (final entry in amounts.entries)
        CategorySpending(
          label: entry.key,
          amount: entry.value,
          percentage: entry.value / total * 100,
        ),
    ]..sort((a, b) => b.amount.compareTo(a.amount));
  }

  // Neto del mes sobre el saldo que había al inicio del mes. Es 0 si ese saldo
  // no es positivo, porque el porcentaje no tendría sentido.
  double monthGrowthPercent(double currentBalance) {
    final net = _thisMonth
        .where((m) => m.countsInBalance)
        .fold(0.0, (sum, m) => sum + m.signedAmount);
    final startBalance = currentBalance - net;
    return startBalance > 0 ? net / startBalance * 100 : 0;
  }
}
