import 'dart:math' as math;

// Modelo simple para cada objetivo de ahorro.
class ObjetivoAhorro {
  final String titulo;
  final double montoActual;
  final double montoObjetivo;

  const ObjetivoAhorro({
    required this.titulo,
    required this.montoActual,
    required this.montoObjetivo,
  });

  double get progreso => montoActual / montoObjetivo;
  int get porcentaje => (progreso * 100).round();

  // Lo que falta para llegar a la meta (nunca negativo).
  double get restante => math.max(0.0, montoObjetivo - montoActual);
}
