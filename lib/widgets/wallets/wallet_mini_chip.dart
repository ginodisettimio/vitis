import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/utils/money_formatter.dart';

/// Versión compacta de WalletCard para el Dashboard: un chip chico
/// con el balance, pensado para una fila horizontal.
class WalletMiniChip extends StatelessWidget {
  final String bankKey;
  final double balance;

  const WalletMiniChip({
    required this.bankKey,
    required this.balance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color bankColor = AppTheme.bankColors[bankKey] ?? AppTheme.primary;
    final money = formatearMonto(balance);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).highlightColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: bankColor,
            child: Text(
              bankKey.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            money,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(fontSize: 13, color: AppTheme.primary),
          ),
        ],
      ),
    );
  }
}
