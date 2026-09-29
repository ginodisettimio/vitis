import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/saving_target.dart';
import '../widgets/icon_barrel.dart';

class NewSavingScreen extends StatefulWidget {
  const NewSavingScreen({super.key});

  @override
  State<NewSavingScreen> createState() => _NewSavingScreenState();
}

class _NewSavingScreenState extends State<NewSavingScreen> {
  static const Color morado = AppTheme.primary;
  static const Color moradoClaro = AppTheme.inputLight;
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
        final meta = double.tryParse(_metaController.text.replaceAll('.', '').replaceAll(',', '.'));
        return meta != null && meta > 0;
      case 2:
        // La reserva inicial puede ser 0, así que solo pedimos que el campo tenga contenido válido.
        final texto = _reservaController.text.replaceAll('.', '').replaceAll(',', '.');
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
    final meta = double.parse(_metaController.text.replaceAll('.', '').replaceAll(',', '.'));
    final reservaTexto = _reservaController.text.replaceAll('.', '').replaceAll(',', '.');
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EncabezadoWizard(onBack: _atras, pasoActual: _pasoActual, totalPasos: pasos.length),
              const SizedBox(height: 16),
              _BarraProgreso(pasoActual: _pasoActual, totalPasos: pasos.length, color: morado),
              const SizedBox(height: 16),
              _TabsPasos(pasos: pasos, pasoActual: _pasoActual, color: morado),
              const SizedBox(height: 32),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: _contenidoPaso(),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _puedeContinuar ? _continuar : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: morado,
                    disabledBackgroundColor: morado.withOpacity(0.4),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _pasoActual == pasos.length - 1 ? 'Crear ahorro' : 'Continuar',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contenidoPaso() {
    switch (_pasoActual) {
      case 0:
        return _PasoFormulario(
          key: const ValueKey('paso-nombre'),
          titulo: '¿Cómo se llama tu ahorro?',
          subtitulo: 'Dale un nombre a tu objetivo',
          hint: 'Ej: Viaje a la playa, Auto nuevo...',
          controller: _nombreController,
          onChanged: (_) => setState(() {}),
          color: morado,
          colorFondoIcono: moradoClaro,
        );
      case 1:
        return _PasoFormulario(
          key: const ValueKey('paso-meta'),
          titulo: '¿Cuál es tu meta?',
          subtitulo: 'Monto total que querés ahorrar',
          hint: 'Ej: 150000',
          controller: _metaController,
          onChanged: (_) => setState(() {}),
          color: morado,
          colorFondoIcono: moradoClaro,
          teclado: TextInputType.number,
          prefijo: '\$ ',
        );
      case 2:
      default:
        return _PasoFormulario(
          key: const ValueKey('paso-reserva'),
          titulo: '¿Cuánto querés reservar ahora?',
          subtitulo: 'Podés arrancar en \$0 y sumar después',
          hint: 'Ej: 20000',
          controller: _reservaController,
          onChanged: (_) => setState(() {}),
          color: morado,
          colorFondoIcono: moradoClaro,
          teclado: TextInputType.number,
          prefijo: '\$ ',
        );
    }
  }
}

class _EncabezadoWizard extends StatelessWidget {
  final VoidCallback onBack;
  final int pasoActual;
  final int totalPasos;

  const _EncabezadoWizard({
    required this.onBack,
    required this.pasoActual,
    required this.totalPasos,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.inputLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.chevron_left, color: AppTheme.primary),
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Crear Ahorro',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
                color: AppTheme.textDark,
              ),
            ),
            Text(
              'Paso ${pasoActual + 1} de $totalPasos',
              style: const TextStyle(color: AppTheme.textGrey, fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}

class _BarraProgreso extends StatelessWidget {
  final int pasoActual;
  final int totalPasos;
  final Color color;

  const _BarraProgreso({
    required this.pasoActual,
    required this.totalPasos,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalPasos, (i) {
        final activo = i <= pasoActual;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: i == totalPasos - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: activo ? color : AppTheme.inputLight,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}

class _TabsPasos extends StatelessWidget {
  final List<String> pasos;
  final int pasoActual;
  final Color color;

  const _TabsPasos({
    required this.pasos,
    required this.pasoActual,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(pasos.length, (i) {
        final activo = i == pasoActual;
        return Text(
          pasos[i],
          style: TextStyle(
            color: activo ? color : AppTheme.textGrey,
            fontWeight: activo ? FontWeight.w800 : FontWeight.normal,
            fontSize: 13,
          ),
        );
      }),
    );
  }
}

class _PasoFormulario extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final Color color;
  final Color colorFondoIcono;
  final TextInputType teclado;
  final String? prefijo;

  const _PasoFormulario({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.hint,
    required this.controller,
    required this.onChanged,
    required this.color,
    required this.colorFondoIcono,
    this.teclado = TextInputType.text,
    this.prefijo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorFondoIcono,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconoBarril(color: color, size: 36),
            ),
            Positioned(
              bottom: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 4),
                  ],
                ),
                child: Icon(Icons.edit, size: 14, color: color),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppTheme.textDark,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitulo,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          onChanged: onChanged,
          keyboardType: teclado,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: hint,
            prefixText: prefijo,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: color.withOpacity(0.4)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: color.withOpacity(0.4)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: color, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}