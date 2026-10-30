import 'package:flutter/material.dart';
import 'package:vitis/data/models/movement.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/utils/date_formatter.dart';
import 'package:vitis/utils/money_formatter.dart';

class TransactionTile extends StatelessWidget {
  final Movement movement;
  final VoidCallback? onTap;

  const TransactionTile({required this.movement, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final color = movement.isIncome ? AppTheme.success : AppTheme.error;
    final amount = formatearMontoConSigno(movement.signedAmount);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppTheme.inputLight,
              child: Icon(
                movement.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: movement.isIncome ? AppTheme.success : AppTheme.error,
                size: 16,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movement.title,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    dayLabel(movement.date),
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontSize: 11),
                  ),
                ],
              ),
            ),
            Text(
              amount,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
