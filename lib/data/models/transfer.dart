import 'package:vitis/data/parsers/transfer_parser.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/wallet.dart';

class Transfer {
  // Se muestra al usuario: coincide con la categoría del dashboard.
  static const String defaultCategory = 'Otros';

  final String? id; // null hasta que se guarda en la base
  final String userId;
  final String walletId;
  final Map<String, Object?> response; // tal como lo envió la API
  final String title;
  final double amount;
  final MovementType type;
  final DateTime date;
  final String category;

  const Transfer({
    this.id,
    required this.userId,
    required this.walletId,
    required this.response,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
    required this.category,
  });

  // Lanza StateError si la billetera no está guardada o no tiene parser.
  factory Transfer.fromResponse(Wallet wallet, Map<String, Object?> response) {
    final walletId = wallet.id;
    if (walletId == null) {
      throw StateError('Wallet ${wallet.name} is not saved');
    }
    final parser = parsersByProvider[wallet.providerKey];
    if (parser == null) {
      throw StateError('No parser for ${wallet.providerKey}');
    }
    final data = parser.parse(response);
    return Transfer(
      userId: wallet.userId,
      walletId: walletId,
      response: response,
      title: data.title,
      amount: data.amount,
      type: data.type,
      date: data.date,
      category: data.category ?? defaultCategory,
    );
  }

  Map<String, Object?> toMap() => {
    'userId': userId,
    'walletId': walletId,
    'response': response,
    'title': title,
    'amount': amount,
    'type': type.name,
    'date': date.toUtc().toIso8601String(),
    'category': category,
  };

  factory Transfer.fromMap(String id, Map<String, Object?> map) => Transfer(
    id: id,
    userId: map['userId'] as String,
    walletId: map['walletId'] as String,
    response: Map<String, Object?>.from(map['response'] as Map),
    title: map['title'] as String,
    amount: (map['amount'] as num).toDouble(),
    type: MovementType.values.byName(map['type'] as String),
    date: DateTime.parse(map['date'] as String),
    category: map['category'] as String,
  );
}
