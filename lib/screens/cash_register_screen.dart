import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/widgets/amount_input.dart';
import 'package:vitis/widgets/back_header.dart';
import 'package:vitis/widgets/form_btn.dart';
import 'package:vitis/widgets/segmented_toggle.dart';

enum TipoRegistro { salida, ingreso }

class CashRegisterScreen extends StatefulWidget {
  const CashRegisterScreen({super.key});

  @override
  State<CashRegisterScreen> createState() => _CashRegisterScreenState();
}

class _CashRegisterScreenState extends State<CashRegisterScreen> {
  TipoRegistro _tipo = TipoRegistro.salida;
  final TextEditingController _montoController = TextEditingController();

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  double? get _monto {
    final texto = _montoController.text
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(texto);
  }

  bool get _isValid => (_monto ?? 0) > 0;

  void _guardar() {
    if (!_isValid) return;

    // TODO: acá conectás la lógica real de guardado (API, base local, etc.)
    debugPrint('Guardar ${_tipo.name}: \$${_monto!.toStringAsFixed(2)}');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorTipo = _tipo == TipoRegistro.salida
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
                    SegmentedToggle<TipoRegistro>(
                      seleccionado: _tipo,
                      onChanged: (tipo) => setState(() => _tipo = tipo),
                      opciones: [
                        SegmentedOption(
                          valor: TipoRegistro.salida,
                          texto: 'Salida',
                          color: theme.colorScheme.error,
                        ),
                        const SegmentedOption(
                          valor: TipoRegistro.ingreso,
                          texto: 'Ingreso',
                          color: AppTheme.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Monto
                    AmountInput(
                      controller: _montoController,
                      prefijo: _tipo == TipoRegistro.salida ? '-\$' : '+\$',
                      color: colorTipo,
                      onChanged: (_) => setState(() {}),
                    ),

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
