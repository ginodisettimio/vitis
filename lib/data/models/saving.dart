import 'dart:math' as math;

class Saving {
  final String? id; // null hasta que se guarda en la base
  final String userId;
  final String name;
  final double reserved;
  final double target;
  final String icon;

  const Saving({
    this.id,
    required this.userId,
    required this.name,
    required this.reserved,
    required this.target,
    required this.icon,
  });

  double get progress => target == 0 ? 0 : (reserved / target).clamp(0, 1);
  int get percent => (progress * 100).round();

  // Lo que falta para llegar a la meta (nunca negativo).
  double get remaining => math.max(0.0, target - reserved);

  Saving copyWith({String? id, double? reserved}) => Saving(
    id: id ?? this.id,
    userId: userId,
    name: name,
    reserved: reserved ?? this.reserved,
    target: target,
    icon: icon,
  );

  Map<String, Object?> toMap() => {
    'userId': userId,
    'name': name,
    'reserved': reserved,
    'target': target,
    'icon': icon,
  };

  factory Saving.fromMap(String id, Map<String, Object?> map) => Saving(
    id: id,
    userId: map['userId'] as String,
    name: map['name'] as String,
    reserved: (map['reserved'] as num).toDouble(),
    target: (map['target'] as num).toDouble(),
    icon: map['icon'] as String,
  );
}
