import 'package:flutter/material.dart';

import 'utils/app_theme.dart';

// Ícono de barril dibujado a mano (Flutter no trae uno en su set de Material Icons).
class IconoBarril extends StatelessWidget {
  final Color color;
  final double size;

  const IconoBarril({super.key, required this.color, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _BarrilPainter(color: color)),
    );
  }
}

class _BarrilPainter extends CustomPainter {
  final Color color;

  _BarrilPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final paintRelleno = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final paintLinea = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round;

    // Cuerpo del barril: más ancho en el medio, angosto arriba y abajo.
    final cuerpo = Path()
      ..moveTo(w * 0.28, h * 0.08)
      ..quadraticBezierTo(w * 0.05, h * 0.30, w * 0.05, h * 0.50)
      ..quadraticBezierTo(w * 0.05, h * 0.70, w * 0.28, h * 0.92)
      ..lineTo(w * 0.72, h * 0.92)
      ..quadraticBezierTo(w * 0.95, h * 0.70, w * 0.95, h * 0.50)
      ..quadraticBezierTo(w * 0.95, h * 0.30, w * 0.72, h * 0.08)
      ..close();
    canvas.drawPath(cuerpo, paintRelleno);

    // Aros del barril (arriba y abajo) en un tono más claro.
    final paintAro = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06;
    canvas.drawLine(
      Offset(w * 0.10, h * 0.28),
      Offset(w * 0.90, h * 0.28),
      paintAro,
    );
    canvas.drawLine(
      Offset(w * 0.10, h * 0.72),
      Offset(w * 0.90, h * 0.72),
      paintAro,
    );

    // Tapa superior (línea curva sugiriendo la tapa del barril).
    canvas.drawLine(
      Offset(w * 0.30, h * 0.08),
      Offset(w * 0.70, h * 0.08),
      paintLinea,
    );
  }

  @override
  bool shouldRepaint(covariant _BarrilPainter oldDelegate) =>
      oldDelegate.color != color;
}

void main() => runApp(const MisAhorrosApp());

class MisAhorrosApp extends StatelessWidget {
  const MisAhorrosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mis Ahorros',
      theme: AppTheme.lightTheme,
      home: const MisAhorrosScreen(),
    );
  }
}

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

class MisAhorrosScreen extends StatefulWidget {
  const MisAhorrosScreen({super.key});

  @override
  State<MisAhorrosScreen> createState() => _MisAhorrosScreenState();
}

class _MisAhorrosScreenState extends State<MisAhorrosScreen> {
  // Datos de ejemplo — reemplazá esto por tu fuente real (API, base local, etc.)
  // Ya no es const: ahora es una lista mutable para poder agregar objetivos nuevos.
  final List<ObjetivoAhorro> objetivos = [
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

  static const Color morado = AppTheme.primary;
  static const Color moradoClaro = AppTheme.inputLight;

  // Índice del objetivo actualmente desplegado (null = ninguno).
  int? _indiceExpandido;
  final TextEditingController _montoController = TextEditingController();

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  void _toggleExpandido(int index) {
    setState(() {
      if (_indiceExpandido == index) {
        _indiceExpandido = null;
      } else {
        _indiceExpandido = index;
      }
      _montoController.clear();
    });
  }

  void _retirar(int index) {
    final texto = _montoController.text
        .replaceAll('.', '')
        .replaceAll(',', '.');
    final monto = double.tryParse(texto);
    if (monto == null || monto <= 0) return;

    // TODO: acá conectás la lógica real de retiro (API, base local, etc.)
    debugPrint(
      'Retirar \$${monto.toStringAsFixed(2)} de ${objetivos[index].titulo}',
    );

    setState(() {
      _indiceExpandido = null;
      _montoController.clear();
    });
  }

  Future<void> _abrirCrearAhorro() async {
    final nuevoObjetivo = await Navigator.of(context).push<ObjetivoAhorro>(
      MaterialPageRoute(builder: (_) => const CrearAhorroScreen()),
    );
    if (nuevoObjetivo != null) {
      setState(() {
        objetivos.add(nuevoObjetivo);
      });
    }
  }

  double get totalAhorrado =>
      objetivos.fold(0, (sum, o) => sum + o.montoActual);

  String _formatearMonto(double monto) {
    // Formato simple con separador de miles con punto y coma decimal.
    final entero = monto.toInt();
    final str = entero.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return '\$ $buffer,00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                cantidadObjetivos: objetivos.length,
                total: totalAhorrado,
              ),
              const SizedBox(height: 20),
              _TotalCard(monto: _formatearMonto(totalAhorrado), color: morado),
              const SizedBox(height: 20),
              ...List.generate(objetivos.length, (index) {
                final o = objetivos[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ObjetivoCard(
                    objetivo: o,
                    formatear: _formatearMonto,
                    colorAcento: morado,
                    colorFondoIcono: moradoClaro,
                    expandido: _indiceExpandido == index,
                    onTap: () => _toggleExpandido(index),
                    montoController: _montoController,
                    onRetirar: () => _retirar(index),
                  ),
                );
              }),
              _BotonCrearAhorro(color: morado, onTap: _abrirCrearAhorro),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: morado,
        shape: const CircleBorder(),
        onPressed: _abrirCrearAhorro,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNavBar(colorActivo: morado),
    );
  }
}

class _Header extends StatelessWidget {
  final int cantidadObjetivos;
  final double total;

  const _Header({required this.cantidadObjetivos, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            IconoBarril(color: AppTheme.primary, size: 22),
            SizedBox(width: 8),
            Text(
              'Mis Ahorros',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$cantidadObjetivos objetivos · \$ ${total.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => '.')},00 reservados',
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
        ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  final String monto;
  final Color color;

  const _TotalCard({required this.monto, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const IconoBarril(color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              const Text(
                'TOTAL AHORRADO',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            monto,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ObjetivoCard extends StatelessWidget {
  final ObjetivoAhorro objetivo;
  final String Function(double) formatear;
  final Color colorAcento;
  final Color colorFondoIcono;
  final bool expandido;
  final VoidCallback onTap;
  final TextEditingController montoController;
  final VoidCallback onRetirar;

  const _ObjetivoCard({
    required this.objetivo,
    required this.formatear,
    required this.colorAcento,
    required this.colorFondoIcono,
    required this.expandido,
    required this.onTap,
    required this.montoController,
    required this.onRetirar,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorFondoIcono,
                    shape: BoxShape.circle,
                  ),
                  child: IconoBarril(color: colorAcento, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        objetivo.titulo,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${formatear(objetivo.montoActual)} de ${formatear(objetivo.montoObjetivo)}',
                        style: const TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${objetivo.porcentaje}%',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorAcento,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: objetivo.progreso.clamp(0, 1),
                minHeight: 8,
                backgroundColor: const Color(0xFFEDEAF7),
                valueColor: AlwaysStoppedAnimation(colorAcento),
              ),
            ),
            // Sección desplegable de retiro, con animación de alto.
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: expandido
                  ? Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Retirar dinero de este ahorro',
                            style: TextStyle(
                              color: AppTheme.textGrey,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: montoController,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  decoration: InputDecoration(
                                    hintText: 'Monto a retirar',
                                    filled: true,
                                    fillColor: colorFondoIcono.withOpacity(0.5),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: onRetirar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorAcento,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Retirar',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotonCrearAhorro extends StatelessWidget {
  final Color color;
  final VoidCallback onTap;

  const _BotonCrearAhorro({required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.4),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: color, size: 18),
            const SizedBox(width: 6),
            Text(
              'Crear nuevo ahorro',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final Color colorActivo;

  const _BottomNavBar({required this.colorActivo});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: Colors.white,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.credit_card,
              label: 'Cuentas',
              activo: false,
              color: colorActivo,
            ),
            _NavItem(
              icon: Icons.eco_outlined,
              label: 'Inicio',
              activo: false,
              color: colorActivo,
            ),
            const SizedBox(width: 40), // espacio para el FAB
            _NavItem(
              esBarril: true,
              label: 'Ahorro',
              activo: true,
              color: colorActivo,
            ),
            _NavItem(
              icon: Icons.bar_chart_outlined,
              label: 'Gastos',
              activo: false,
              color: colorActivo,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// Pantalla "Crear Ahorro" — formulario de 3 pasos (wizard).
// ============================================================

class CrearAhorroScreen extends StatefulWidget {
  const CrearAhorroScreen({super.key});

  @override
  State<CrearAhorroScreen> createState() => _CrearAhorroScreenState();
}

class _CrearAhorroScreenState extends State<CrearAhorroScreen> {
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EncabezadoWizard(
                onBack: _atras,
                pasoActual: _pasoActual,
                totalPasos: pasos.length,
              ),
              const SizedBox(height: 16),
              _BarraProgreso(
                pasoActual: _pasoActual,
                totalPasos: pasos.length,
                color: morado,
              ),
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
                    _pasoActual == pasos.length - 1
                        ? 'Crear ahorro'
                        : 'Continuar',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
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
                fontWeight: FontWeight.bold,
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
            fontWeight: activo ? FontWeight.bold : FontWeight.normal,
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
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
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
            fontWeight: FontWeight.bold,
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
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

class _NavItem extends StatelessWidget {
  final IconData? icon; // Para íconos estándar de Material.
  final bool esBarril; // Para usar el IconoBarril dibujado a mano.
  final String label;
  final bool activo;
  final Color color;

  const _NavItem({
    this.icon,
    this.esBarril = false,
    required this.label,
    required this.activo,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = activo ? color : AppTheme.textGrey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        esBarril
            ? IconoBarril(color: c, size: 22)
            : Icon(icon, color: c, size: 22),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: c, fontSize: 11)),
      ],
    );
  }
}
