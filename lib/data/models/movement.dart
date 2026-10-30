import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/transfer.dart';
import 'package:vitis/data/models/wallet.dart';

// Vista común de Cash y Transfer para las listas de la app.
class Movement {
  final String title;
  final String source; // de dónde salió: nombre de la billetera o 'Efectivo'
  final String? providerKey; // null en efectivo
  final DateTime date; // en hora local
  final double signedAmount; // positivo = ingreso, negativo = egreso
  final String category;
  final bool countsInBalance; // false si su billetera está desconectada

  const Movement({
    required this.title,
    required this.source,
    this.providerKey,
    required this.date,
    required this.signedAmount,
    required this.category,
    this.countsInBalance = true,
  });

  bool get isIncome => signedAmount >= 0;

  factory Movement.fromCash(Cash cash) => Movement(
    title: cash.note ?? 'Efectivo',
    source: 'Efectivo',
    date: cash.date.toLocal(),
    signedAmount: _signed(cash.amount, cash.type),
    category: Transfer.defaultCategory,
  );

  factory Movement.fromTransfer(Transfer transfer, Wallet? wallet) => Movement(
    title: transfer.title,
    source: wallet?.name ?? 'Billetera',
    providerKey: wallet?.providerKey,
    date: transfer.date.toLocal(),
    signedAmount: _signed(transfer.amount, transfer.type),
    category: transfer.category,
    countsInBalance: wallet?.status != WalletStatus.disconnected,
  );

  static double _signed(double amount, MovementType type) =>
      type == MovementType.income ? amount : -amount;
}
