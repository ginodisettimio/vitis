import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../models/saving_target.dart';
import '../widgets/icon_barrel.dart';
import 'new_saving_screen.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
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
    final texto = _montoController.text.replaceAll('.', '').replaceAll(',', '.');
    final monto = double.tryParse(texto);
    if (monto == null || monto <= 0) return;

    // TODO: acá conectás la lógica real de retiro (API, base local, etc.)
    debugPrint('Retirar \$${monto.toStringAsFixed(2)} de ${objetivos[index].titulo}');

    setState(() {
      _indiceExpandido = null;
      _montoController.clear();
    });
  }

  Future<void> _abrirCrearAhorro() async {
    final nuevoObjetivo = await Navigator.of(context).push<ObjetivoAhorro>(
      MaterialPageRoute(builder: (_) => const NewSavingScreen()),
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
              _Header(cantidadObjetivos: objetivos.length, total: totalAhorrado),
              const SizedBox(height: 20),
              _TotalCard(
                monto: _formatearMonto(totalAhorrado),
                color: morado,
              ),
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
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          '$cantidadObjetivos objetivos · \$ ${total.toStringAsFixed(0).replaceAllMapped(
                RegExp(r'\B(?=(\d{3})+(?!\d))'),
                (m) => '.',
              )},00 reservados',
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
              fontWeight: FontWeight.w900,
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
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppTheme.textDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${formatear(objetivo.montoActual)} de ${formatear(objetivo.montoObjetivo)}',
                        style: const TextStyle(color: AppTheme.textGrey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${objetivo.porcentaje}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
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
                            style: TextStyle(color: AppTheme.textGrey, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: montoController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
          border: Border.all(color: color.withOpacity(0.4), style: BorderStyle.solid),
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
            _NavItem(icon: Icons.credit_card, label: 'Cuentas', activo: false, color: colorActivo),
            _NavItem(icon: Icons.eco_outlined, label: 'Inicio', activo: false, color: colorActivo),
            const SizedBox(width: 40), // espacio para el FAB
            _NavItem(esBarril: true, label: 'Ahorro', activo: true, color: colorActivo),
            _NavItem(icon: Icons.bar_chart_outlined, label: 'Gastos', activo: false, color: colorActivo),
          ],
        ),
      ),
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
        esBarril ? IconoBarril(color: c, size: 22) : Icon(icon, color: c, size: 22),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: c, fontSize: 11)),
      ],
    );
  }
}