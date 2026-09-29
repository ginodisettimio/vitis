import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitis/models/dashboard_models.dart';
import 'package:vitis/utils/app_theme.dart';

class SavingGoalCard extends StatelessWidget {
  final SavingGoal goal;

  const SavingGoalCard({required this.goal, super.key});

  String _money(double value) {
    return NumberFormat.currency(
      locale: 'es_AR',
      symbol: '\$ ',
      decimalDigits: 0,
    ).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Theme.of(context).highlightColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            goal.name,
            style: Theme.of(context).textTheme.bodyLarge
                ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Text(
            _money(goal.current),
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: goal.progress,
              minHeight: 6,
              backgroundColor: AppTheme.inputLight,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(goal.progress * 100).round()}% de ${_money(goal.target)}',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}
