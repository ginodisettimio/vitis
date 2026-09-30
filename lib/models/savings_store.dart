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
}
