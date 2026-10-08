import 'package:flutter/material.dart';
import 'package:vitis/models/saving_target.dart';
import 'package:vitis/utils/money_formatter.dart';
import 'package:vitis/widgets/icons/icon_barrel.dart';

// Tarjeta de un objetivo de ahorro. Al tocarla se despliega la sección de retiro.
class SavingTargetCard extends StatelessWidget {
  final ObjetivoAhorro objetivo;
  final bool expandido;
  final VoidCallback onTap;
  final TextEditingController montoController;
  final VoidCallback onRetirar;

  const SavingTargetCard({
    super.key,
    required this.objetivo,
    required this.expandido,
    required this.onTap,
    required this.montoController,
    required this.onRetirar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final primarySoft = primary.withValues(alpha: 0.12);
    final cardShape = theme.cardTheme.shape as RoundedRectangleBorder?;
    final borderRadius =
        cardShape?.borderRadius as BorderRadius? ?? BorderRadius.circular(18);

    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: borderRadius,
          border: cardShape != null
              ? Border.fromBorderSide(cardShape.side)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
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
                    color: primarySoft,
                    shape: BoxShape.circle,
                  ),
                  child: IconoBarril(color: primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        objetivo.titulo,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${formatearMonto(objetivo.montoActual)} de ${formatearMonto(objetivo.montoObjetivo)}',
                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${objetivo.porcentaje}%',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: primary,
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
                backgroundColor: primarySoft,
                valueColor: AlwaysStoppedAnimation(primary),
              ),
            ),
            // Sección desplegable de retiro, con animación de alto.
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: expandido
                  ? _SeccionRetiro(
                      montoController: montoController,
                      onRetirar: onRetirar,
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeccionRetiro extends StatelessWidget {
  final TextEditingController montoController;
  final VoidCallback onRetirar;

  const _SeccionRetiro({
    required this.montoController,
    required this.onRetirar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final radius = BorderRadius.circular(12);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Retirar dinero de este ahorro',
            style: theme.textTheme.bodyMedium?.copyWith(fontSize: 13),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                // Relleno y colores salen de inputDecorationTheme.
                child: TextField(
                  controller: montoController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'Monto a retirar',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: radius,
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: radius,
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: onRetirar,
                style: theme.elevatedButtonTheme.style?.copyWith(
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(borderRadius: radius),
                  ),
                  textStyle: const WidgetStatePropertyAll(
                    TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                child: const Text('Retirar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
