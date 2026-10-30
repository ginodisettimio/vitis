import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:vitis/data/models/saving.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/data/states/savings_store.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/data/states/wallets_store.dart';
import 'package:vitis/ui/widgets/feedback/app_snack_bar.dart';
import 'package:vitis/utils/money_formatter.dart';
import 'package:vitis/ui/widgets/icons/icon_barrel.dart';
import 'package:vitis/ui/widgets/feedback/empty_message.dart';
import 'package:vitis/ui/widgets/forms/outlined_add_button.dart';
import 'package:vitis/ui/widgets/savings/saving_target_card.dart';
import 'package:vitis/ui/widgets/savings/savings_total_card.dart';
import 'package:vitis/ui/widgets/headers/screen_header.dart';
import 'package:vitis/ui/screens/savings/new_saving_screen.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  final SavingsStore _store = SavingsStore.instance;

  // Índice del objetivo actualmente desplegado (null = ninguno).
  int? _indiceExpandido;
  final TextEditingController _montoController = TextEditingController();
  bool _saving = false;

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

  // No se puede reservar más de lo disponible ni pasar de la meta.
  double _maxDeposito(Saving saving) =>
      math.min(saving.remaining, SessionStore.instance.availableBalance);

  Future<void> _depositar(int index) async {
    final monto = _montoIngresado;
    final saving = _store.savings[index];
    if (monto == null || monto > _maxDeposito(saving)) return;

    await _guardar(() => _store.deposit(saving.id!, monto));
  }

  Future<void> _retirar(int index) async {
    final monto = _montoIngresado;
    final saving = _store.savings[index];
    if (monto == null || monto > saving.reserved) return;

    await _guardar(() => _store.withdraw(saving.id!, monto));
  }

  Future<void> _guardar(Future<void> Function() operacion) async {
    if (_saving) return;
    _saving = true;

    try {
      await operacion();
      if (mounted) _cerrarSeccion();
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      _saving = false;
    }
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
        // Se redibuja cuando cambian los ahorros o lo disponible para depositar.
        child: ListenableBuilder(
          listenable: Listenable.merge([
            _store,
            WalletsStore.instance,
            MovementsStore.instance,
          ]),
          builder: (context, _) {
            final savings = _store.savings;
            final total = _store.totalReserved;

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
                        '${savings.length} ${savings.length == 1 ? 'objetivo' : 'objetivos'} · ${formatearMonto(total)} reservados',
                  ),
                  const SizedBox(height: 20),
                  SavingsTotalCard(monto: formatearMonto(total)),
                  const SizedBox(height: 20),
                  if (savings.isEmpty)
                    const EmptyMessage('Todavía no creaste ningún ahorro'),
                  ...List.generate(savings.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: SavingTargetCard(
                        saving: savings[index],
                        maxDeposito: _maxDeposito(savings[index]),
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
