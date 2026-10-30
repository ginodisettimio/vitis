import 'package:flutter/material.dart';
import 'package:vitis/data/models/wallet.dart';
import 'package:vitis/utils/app_theme.dart';

class WalletCard extends StatelessWidget {
  final String bankKey;
  final String title;
  final WalletStatus status;
  final VoidCallback onDisconnect;

  const WalletCard({
    required this.bankKey,
    required this.title,
    required this.status,
    required this.onDisconnect,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color bankColor = AppTheme.bankColors[bankKey] ?? AppTheme.primary;
    final connected = status == WalletStatus.connected;
    final Color statusColor = connected ? AppTheme.success : AppTheme.textGrey;

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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(fontSize: 14, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      connected ? 'Conectado' : 'Sin sincronizar',
                      style: TextStyle(
                        color: statusColor.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.link_off),
            tooltip: 'Desconectar',
            color: AppTheme.textGrey,
            onPressed: onDisconnect,
          ),
        ],
      ),
    );
  }
}
