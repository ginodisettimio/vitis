import 'package:flutter/material.dart';

import 'package:vitis/models/saving_target.dart';
import 'package:vitis/models/savings_store.dart';
import 'package:vitis/widgets/icons/icon_barrel.dart';
import 'package:vitis/widgets/wizard/step_progress_bar.dart';
import 'package:vitis/widgets/wizard/step_tabs.dart';
import 'package:vitis/widgets/wizard/wizard_header.dart';
import 'package:vitis/widgets/wizard/wizard_next_button.dart';
import 'package:vitis/widgets/wizard/wizard_step_form.dart';

class NewSavingScreen extends StatefulWidget {
  const NewSavingScreen({super.key});

  // Abre el flujo de creación y guarda el objetivo en SavingsStore.
  // Devuelve true si se creó un ahorro.
  static Future<bool> abrir(BuildContext context) async {
    final nuevoObjetivo = await Navigator.of(context).push<ObjetivoAhorro>(
      MaterialPageRoute(builder: (_) => const NewSavingScreen()),
    );
    if (nuevoObjetivo == null) return false;
    SavingsStore.instancia.agregar(nuevoObjetivo);
    return true;
  }

  @override
  State<NewSavingScreen> createState() => _NewSavingScreenState();
}

class _NewSavingScreenState extends State<NewSavingScreen> {
  static const List<String> pasos = ['Nombre', 'Meta', 'Reserva'];

  int _pasoActual = 0; // 0 = Nombre, 1 = Meta, 2 = Reserva

  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _metaController = TextEditingController();
  final TextEditingController _reservaController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _metaController.dispose();
    _reservaController.dispose();
    super.dispose();
  }

  // El botón "Continuar" solo se habilita si el paso actual tiene datos válidos.
  bool get _puedeContinuar {
    switch (_pasoActual) {
      case 0:
        return _nombreController.text.trim().isNotEmpty;
      case 1:
        final meta = double.tryParse(
          _metaController.text.replaceAll('.', '').replaceAll(',', '.'),
        );
        return meta != null && meta > 0;
      case 2:
        // La reserva inicial puede ser 0, así que solo pedimos que el campo tenga contenido válido.
        final texto = _reservaController.text
            .replaceAll('.', '')
            .replaceAll(',', '.');
        return texto.isEmpty || double.tryParse(texto) != null;
      default:
        return false;
    }
  }

  void _continuar() {
    if (!_puedeContinuar) return;
    if (_pasoActual < pasos.length - 1) {
      setState(() => _pasoActual++);
    } else {
      _crearAhorro();
    }
  }

  void _atras() {
    if (_pasoActual == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _pasoActual--);
    }
  }

  void _crearAhorro() {
    final nombre = _nombreController.text.trim();
    final meta = double.parse(
      _metaController.text.replaceAll('.', '').replaceAll(',', '.'),
    );
    final reservaTexto = _reservaController.text
        .replaceAll('.', '')
        .replaceAll(',', '.');
    final reserva = reservaTexto.isEmpty ? 0.0 : double.parse(reservaTexto);

    final nuevoObjetivo = ObjetivoAhorro(
      titulo: nombre,
      montoActual: reserva.clamp(0, meta),
      montoObjetivo: meta,
    );

    Navigator.of(context).pop(nuevoObjetivo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WizardHeader(
                titulo: 'Crear Ahorro',
                pasoActual: _pasoActual,
                totalPasos: pasos.length,
                onBack: _atras,
              ),
              const SizedBox(height: 16),
              StepProgressBar(
                pasoActual: _pasoActual,
                totalPasos: pasos.length,
              ),
              const SizedBox(height: 16),
              StepTabs(pasos: pasos, pasoActual: _pasoActual),
              const SizedBox(height: 32),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _contenidoPaso(),
                ),
              ),
              WizardNextButton(
                texto: _pasoActual == pasos.length - 1
                    ? 'Crear ahorro'
                    : 'Continuar',
                onPressed: _puedeContinuar ? _continuar : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenidoPaso() {
    final icono = IconoBarril(
      color: Theme.of(context).colorScheme.primary,
      size: 36,
    );

    switch (_pasoActual) {
      case 0:
        return WizardStepForm(
          key: const ValueKey('paso-nombre'),
          icono: icono,
          titulo: '¿Cómo se llama tu ahorro?',
          subtitulo: 'Dale un nombre a tu objetivo',
          hint: 'Ej: Viaje a la playa, Auto nuevo...',
          controller: _nombreController,
          onChanged: (_) => setState(() {}),
        );
      case 1:
        return WizardStepForm(
          key: const ValueKey('paso-meta'),
          icono: icono,
          titulo: '¿Cuál es tu meta?',
          subtitulo: 'Monto total que querés ahorrar',
          hint: 'Ej: 150000',
          controller: _metaController,
          onChanged: (_) => setState(() {}),
          teclado: TextInputType.number,
          prefijo: '\$ ',
        );
      case 2:
      default:
        return WizardStepForm(
          key: const ValueKey('paso-reserva'),
          icono: icono,
          titulo: '¿Cuánto querés reservar ahora?',
          subtitulo: 'Podés arrancar en \$0 y sumar después',
          hint: 'Ej: 20000',
          controller: _reservaController,
          onChanged: (_) => setState(() {}),
          teclado: TextInputType.number,
          prefijo: '\$ ',
        );
    }
  }
}
