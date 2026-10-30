import 'package:flutter/material.dart';
import 'package:vitis/data/models/saving.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/utils/money_formatter.dart';

class SavingGoalCard extends StatelessWidget {
  final Saving saving;
  final VoidCallback? onTap;

  const SavingGoalCard({required this.saving, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 170,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).highlightColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                saving.name,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontSize: 13, fontWeight: FontWeight.w700),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                formatearMonto(saving.reserved, decimales: 0),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: saving.progress,
                  minHeight: 6,
                  backgroundColor: AppTheme.inputLight,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                // Una sola línea: la tarjeta tiene alto fijo y el monto lo escribe el usuario.
                '${saving.percent}% de ${formatearMonto(saving.target, decimales: 0)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
