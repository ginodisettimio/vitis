import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';

class AccountCard extends StatelessWidget {
  final String bankKey;
  final String title;

  const AccountCard({required this.bankKey, required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    final Color bankColor = AppTheme.bankColors[bankKey] ?? AppTheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: Theme.of(context).cardTheme.shape != null
          ? BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius:
                  (Theme.of(context).cardTheme.shape as RoundedRectangleBorder)
                      .borderRadius,
            )
          : null,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: bankColor,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              bankKey.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppTheme.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Conectado',
                    style: TextStyle(
                      color: AppTheme.success.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
