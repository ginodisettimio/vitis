import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitis/models/dashboard_models.dart';
import 'package:vitis/utils/app_theme.dart';

class TransactionTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionTile({required this.transaction, super.key});

  @override
  Widget build(BuildContext context) {
    final color = transaction.isIncome ? AppTheme.success : AppTheme.error;
    final sign = transaction.isIncome ? '+' : '-';
    final amount = NumberFormat.currency(
      locale: 'es_AR',
      symbol: '\$ ',
      decimalDigits: 0,
    ).format(transaction.amount.abs());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppTheme.inputLight,
            child: Icon(
              transaction.isIncome
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              color: AppTheme.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Text(
                  transaction.date,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            '$sign$amount',
            style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
