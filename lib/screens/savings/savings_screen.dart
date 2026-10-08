import 'package:flutter/material.dart';

import 'package:vitis/models/savings_store.dart';
import 'package:vitis/utils/money_formatter.dart';
import 'package:vitis/widgets/icons/icon_barrel.dart';
import 'package:vitis/widgets/forms/outlined_add_button.dart';
import 'package:vitis/widgets/savings/saving_target_card.dart';
import 'package:vitis/widgets/savings/savings_total_card.dart';
import 'package:vitis/widgets/headers/screen_header.dart';
import 'package:vitis/screens/savings/new_saving_screen.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final SavingsStore _store = SavingsStore.instancia;

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

  // Monto escrito en el campo, o null si no es un número mayor a 0.
  double? get _montoIngresado {
    final monto = parsearMonto(_montoController.text);
    return monto != null && monto > 0 ? monto : null;
  }

  void _depositar(int index) {
    final monto = _montoIngresado;
    if (monto == null || monto > _store.objetivos[index].restante) return;

    _store.depositar(index, monto);
    _cerrarSeccion();
  }

  void _retirar(int index) {
    final monto = _montoIngresado;
    if (monto == null || monto > _store.objetivos[index].montoActual) return;

    _store.retirar(index, monto);
    _cerrarSeccion();
  }

  void _cerrarSeccion() {
    setState(() {
      _indiceExpandido = null;
      _montoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        // Se redibuja cuando cambian los ahorros (nuevo ahorro, depósito o retiro).
        child: ListenableBuilder(
          listenable: _store,
          builder: (context, _) {
            final objetivos = _store.objetivos;
            final total = _store.totalAhorrado;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ScreenHeader(
                    icon: IconoBarril(
                      color: theme.colorScheme.primary,
                      size: 22,
                    ),
                    title: 'Mis Ahorros',
                    subtitle:
                        '${objetivos.length} objetivos · ${formatearMonto(total)} reservados',
                  ),
                  const SizedBox(height: 20),
                  SavingsTotalCard(monto: formatearMonto(total)),
                  const SizedBox(height: 20),
                  ...List.generate(objetivos.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SavingTargetCard(
                        objetivo: objetivos[index],
                        expandido: _indiceExpandido == index,
                        onTap: () => _toggleExpandido(index),
                        montoController: _montoController,
                        onDepositar: () => _depositar(index),
                        onRetirar: () => _retirar(index),
                      ),
                    );
                  }),
                  OutlinedAddButton(
                    text: 'Crear nuevo ahorro',
                    onTap: () => NewSavingScreen.abrir(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
