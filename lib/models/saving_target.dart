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
}