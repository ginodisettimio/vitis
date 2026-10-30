import 'package:flutter/material.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/ui/widgets/feedback/app_snack_bar.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/utils/money_formatter.dart';
import 'package:vitis/ui/widgets/forms/amount_input.dart';
import 'package:vitis/ui/widgets/headers/back_header.dart';
import 'package:vitis/ui/widgets/forms/form_btn.dart';
import 'package:vitis/ui/widgets/forms/segmented_toggle.dart';

class CashRegisterScreen extends StatefulWidget {
  const CashRegisterScreen({super.key});

  @override
  State<CashRegisterScreen> createState() => _CashRegisterScreenState();
}

class _CashRegisterScreenState extends State<CashRegisterScreen> {
  MovementType _tipo = MovementType.expense;
  final TextEditingController _montoController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  double? get _monto => parsearMonto(_montoController.text);

  double get _disponible => SessionStore.instance.availableBalance;

  // Una salida no puede dejar la reserva disponible en negativo.
  bool get _excedeDisponible =>
      _tipo == MovementType.expense && (_monto ?? 0) > _disponible;

  bool get _isValid => (_monto ?? 0) > 0 && !_excedeDisponible;

  Future<void> _guardar() async {
    if (!_isValid || _saving) return;
    _saving = true;

    try {
      await MovementsStore.instance.addCash(amount: _monto!, type: _tipo);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) showErrorSnackBar(context, error);
    } finally {
      _saving = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTipo = _tipo == MovementType.expense
        ? theme.colorScheme.error
        : AppTheme.success;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BackHeader(titulo: 'Nuevo Registro'),
                    const SizedBox(height: 20),

                    // Switch Salida / Ingreso
                    SegmentedToggle<MovementType>(
                      seleccionado: _tipo,
                      onChanged: (tipo) => setState(() => _tipo = tipo),
                      opciones: [
                        SegmentedOption(
                          valor: MovementType.expense,
                          texto: 'Salida',
                          color: theme.colorScheme.error,
                        ),
                        const SegmentedOption(
                          valor: MovementType.income,
                          texto: 'Ingreso',
                          color: AppTheme.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Monto
                    AmountInput(
                      controller: _montoController,
                      prefijo: _tipo == MovementType.expense ? '-\$' : '+\$',
                      color: colorTipo,
                      onChanged: (_) => setState(() {}),
                    ),
                    if (_tipo == MovementType.expense) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Disponible: ${formatearMonto(_disponible)}',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: _excedeDisponible
                              ? theme.colorScheme.error
                              : null,
                        ),
                      ),
                    ],

                    const Spacer(),
                    const SizedBox(height: 24),

                    // Botón Guardar
                    Opacity(
                      opacity: _isValid ? 1.0 : 0.5,
                      child: SizedBox(
                        height: 56,
                        child: FormBtn(
                          text: 'Guardar Registro',
                          onPressed: _guardar,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
