import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/utils/money_formatter.dart';

class BalanceCard extends StatelessWidget {
  final double availableBalance;
  final double reservedInSavings;
  final int syncedBanks;
  final double monthGrowthPercent;

  const BalanceCard({
    required this.availableBalance,
    required this.reservedInSavings,
    required this.syncedBanks,
    required this.monthGrowthPercent,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Mismos colores que Ingreso / Salida en CashRegisterScreen.
    final Color? growthColor = monthGrowthPercent > 0
        ? AppTheme.success
        : monthGrowthPercent < 0
            ? Theme.of(context).colorScheme.error
            : null;
    // El negativo ya trae su "-"; al positivo se le agrega el "+".
    final growthSign = monthGrowthPercent > 0 ? '+' : '';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.primaryDark],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RESERVA DISPONIBLE',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            formatearMonto(availableBalance),
            style: Theme.of(context).textTheme.displayLarge
                ?.copyWith(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 6),
          Text(
            '${formatearMonto(reservedInSavings)} reservados en ahorros',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _Badge(text: '$syncedBanks bancos sincronizados'),
              const SizedBox(width: 8),
              _Badge(
                text:
                    '$growthSign${monthGrowthPercent.toStringAsFixed(1)}% este mes',
                color: growthColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Pastilla de texto blanco. Sin color, usa el fondo blanco translúcido.
class _Badge extends StatelessWidget {
  final String text;
  final Color? color;
  const _Badge({required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
