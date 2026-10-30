import 'package:vitis/data/models/movement_type.dart';

// Lo que la app necesita de la respuesta de cualquier banco.
class TransferData {
  final String title;
  final double amount; // siempre positivo: el sentido lo da type
  final MovementType type;
  final DateTime date;
  final String? category; // null si el banco no la informa

  const TransferData({
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    this.category,
  });
}

// Se implementa una vez por banco. Lanza FormatException si el response no
// tiene el formato esperado.
abstract interface class TransferParser {
  TransferData parse(Map<String, Object?> response);
}

// Indexado por Wallet.providerKey.
final Map<String, TransferParser> parsersByProvider = {};
