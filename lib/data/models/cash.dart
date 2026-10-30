import 'package:vitis/data/models/movement_type.dart';

class Cash {
  final String? id; // null hasta que se guarda en la base
  final String userId;
  final double amount;
  final MovementType type;
  final DateTime date;
  final String? note;

  const Cash({
    this.id,
    required this.userId,
    required this.amount,
    required this.type,
    required this.date,
    this.note,
  });

  Cash copyWith({String? id}) => Cash(
    id: id ?? this.id,
    userId: userId,
    amount: amount,
    type: type,
    date: date,
    note: note,
  );

  Map<String, Object?> toMap() => {
    'userId': userId,
    'amount': amount,
    'type': type.name,
    'date': date.toUtc().toIso8601String(),
    'note': note,
  };

  factory Cash.fromMap(String id, Map<String, Object?> map) => Cash(
    id: id,
    userId: map['userId'] as String,
    amount: (map['amount'] as num).toDouble(),
    type: MovementType.values.byName(map['type'] as String),
    date: DateTime.parse(map['date'] as String),
    note: map['note'] as String?,
  );
}
