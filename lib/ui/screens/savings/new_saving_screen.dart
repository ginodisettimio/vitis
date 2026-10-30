import 'package:flutter/material.dart';

import 'package:vitis/data/states/savings_store.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/ui/widgets/feedback/app_snack_bar.dart';
import 'package:vitis/ui/widgets/icons/icon_barrel.dart';
import 'package:vitis/utils/money_formatter.dart';
import 'package:vitis/ui/widgets/wizard/step_progress_bar.dart';
import 'package:vitis/ui/widgets/wizard/step_tabs.dart';
import 'package:vitis/ui/widgets/wizard/wizard_header.dart';
import 'package:vitis/ui/widgets/wizard/wizard_next_button.dart';
import 'package:vitis/ui/widgets/wizard/wizard_step_form.dart';

class NewSavingScreen extends StatefulWidget {
  const NewSavingScreen({super.key});

  // Abre el flujo de creación y guarda el ahorro en SavingsStore.
  // Devuelve true si se creó un ahorro.
  static Future<bool> abrir(BuildContext context) async {
    final datos = await Navigator.of(context)
        .push<({String name, double reserved, double target})>(
          MaterialPageRoute(builder: (_) => const NewSavingScreen()),
        );
    if (datos == null) return false;
    try {
      await SavingsStore.instance.add(
        name: datos.name,
        reserved: datos.reserved,
        target: datos.target,
      );
      return true;
    } catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
      return false;
    }
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
        final meta = parsearMonto(_metaController.text);
        return meta != null && meta > 0;
      case 2:
        // La reserva inicial puede ser 0, pero no más de lo disponible.
        final texto = _reservaController.text.trim();
        if (texto.isEmpty) return true;
        final reserva = parsearMonto(texto);
        return reserva != null &&
            reserva <= SessionStore.instance.availableBalance;
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
    final meta = parsearMonto(_metaController.text)!;
    final reserva = parsearMonto(_reservaController.text) ?? 0.0;

    Navigator.of(context).pop((
      name: nombre,
      reserved: reserva.clamp(0, meta).toDouble(),
      target: meta,
    ));
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
          subtitulo:
              'Podés arrancar en \$0 y sumar después. '
              'Disponible: ${formatearMonto(SessionStore.instance.availableBalance)}',
          hint: 'Ej: 20000',
          controller: _reservaController,
          onChanged: (_) => setState(() {}),
          teclado: TextInputType.number,
          prefijo: '\$ ',
        );
    }
  }
}
