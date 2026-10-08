import 'package:flutter/material.dart';
import 'package:vitis/widgets/icons/icon_barrel.dart';

// Tarjeta de color primario con el total ahorrado.
class SavingsTotalCard extends StatelessWidget {
  final String monto;
  final String label;

  const SavingsTotalCard({
    super.key,
    required this.monto,
    this.label = 'TOTAL AHORRADO',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = theme.colorScheme.onPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
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
                  color: onPrimary.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: IconoBarril(color: onPrimary, size: 18),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: onPrimary.withValues(alpha: 0.7),
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
            style: TextStyle(
              color: onPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
