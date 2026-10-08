import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:vitis/models/saving_target.dart';

// Lista de objetivos de ahorro compartida por toda la app.
// Las pantallas la escuchan con ListenableBuilder para redibujarse cuando cambia.
class SavingsStore extends ChangeNotifier {
  SavingsStore._();

  static final SavingsStore instancia = SavingsStore._();

  // Datos de ejemplo — reemplazá esto por tu fuente real (API, base local, etc.)
  final List<ObjetivoAhorro> _objetivos = [
    const ObjetivoAhorro(
      titulo: 'Viaje a Bariloche',
      montoActual: 45000,
      montoObjetivo: 150000,
    ),
    const ObjetivoAhorro(
      titulo: 'Fondo de emergencia',
      montoActual: 80000,
      montoObjetivo: 200000,
    ),
  ];

  List<ObjetivoAhorro> get objetivos => List.unmodifiable(_objetivos);

  double get totalAhorrado =>
      _objetivos.fold(0, (sum, o) => sum + o.montoActual);

  void agregar(ObjetivoAhorro objetivo) {
    _objetivos.add(objetivo);
    notifyListeners();
  }

  // TODO: persistir depósitos y retiros (todavía se pierden al cerrar la app).
  // Nunca pasa de la meta: deposita como mucho lo que falta.
  void depositar(int index, double monto) {
    final objetivo = _objetivos[index];
    _cambiarMonto(
      index,
      objetivo.montoActual + math.min(monto, objetivo.restante),
    );
  }

  // Nunca deja el ahorro en negativo: retira como mucho lo que hay.
  void retirar(int index, double monto) {
    _cambiarMonto(index, math.max(0.0, _objetivos[index].montoActual - monto));
  }

  void _cambiarMonto(int index, double montoActual) {
    final objetivo = _objetivos[index];
    _objetivos[index] = ObjetivoAhorro(
      titulo: objetivo.titulo,
      montoActual: montoActual,
      montoObjetivo: objetivo.montoObjetivo,
    );
    notifyListeners();
  }
}
