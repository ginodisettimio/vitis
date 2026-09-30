import 'package:flutter/material.dart';

import '../models/saving_target.dart';
import '../utils/money_formatter.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/icon_barrel.dart';
import '../widgets/outlined_add_button.dart';
import '../widgets/saving_target_card.dart';
import '../widgets/savings_total_card.dart';
import '../widgets/screen_header.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScreenHeader(
                icon: IconoBarril(color: theme.colorScheme.primary, size: 22),
                title: 'Mis Ahorros',
                subtitle:
                    '${objetivos.length} objetivos · ${formatearMonto(totalAhorrado)} reservados',
              ),
              const SizedBox(height: 20),
              SavingsTotalCard(monto: formatearMonto(totalAhorrado)),
              const SizedBox(height: 20),
              ...List.generate(objetivos.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: SavingTargetCard(
                    objetivo: objetivos[index],
                    expandido: _indiceExpandido == index,
                    onTap: () => _toggleExpandido(index),
                    montoController: _montoController,
                    onRetirar: () => _retirar(index),
                  ),
                );
              }),
              OutlinedAddButton(
                text: 'Crear nuevo ahorro',
                onTap: _abrirCrearAhorro,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        shape: const CircleBorder(),
        onPressed: _abrirCrearAhorro,
        child: const Icon(Icons.add, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const AppBottomNavBar(activa: NavSection.ahorro),
    );
  }
}
