import 'package:flutter/material.dart';
import 'package:vitis/data/models/wallet.dart';
import 'package:vitis/data/states/session_store.dart';
import 'package:vitis/data/states/wallets_store.dart';
import 'package:vitis/ui/widgets/feedback/app_snack_bar.dart';
import 'package:vitis/ui/widgets/feedback/empty_message.dart';
import 'package:vitis/ui/widgets/wallets/add_wallet_button.dart';
import 'package:vitis/ui/widgets/wallets/wallet_card.dart';

class MyWalletsScreen extends StatelessWidget {
  const MyWalletsScreen({super.key});

  Future<void> _disconnect(BuildContext context, Wallet wallet) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('¿Desconectar ${wallet.name}?'),
        content: const Text(
          'Su saldo dejará de contarse. Los movimientos ya registrados se conservan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Desconectar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      final disconnected = await SessionStore.instance.disconnectWallet(wallet);
      if (!disconnected && context.mounted) {
        showAppSnackBar(
          context,
          'Primero retirá dinero de tus ahorros: esta billetera los respalda',
        );
      }
    } catch (error) {
      if (context.mounted) showErrorSnackBar(context, error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 10,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          // Se redibuja cuando se agrega una billetera.
          child: ListenableBuilder(
            listenable: WalletsStore.instance,
            builder: (context, _) {
              final store = WalletsStore.instance;
              final wallets = store.wallets;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título principal
                  Text(
                    'Mis Billeteras',
                    style: Theme.of(context).textTheme.displayLarge
                        ?.copyWith(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  // Subtítulo
                  Text(
                    store.connectedCount == 1
                        ? '1 banco sincronizado'
                        : '${store.connectedCount} bancos sincronizados',
                    style: Theme.of(context).textTheme.bodyMedium
                        ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),

                  // Lista de cuentas
                  Expanded(
                    child: ListView(
                      children: [
                        if (wallets.isEmpty)
                          const EmptyMessage('Todavía no agregaste billeteras'),
                        for (final wallet in wallets) ...[
                          WalletCard(
                            bankKey: wallet.providerKey,
                            title: wallet.name,
                            status: wallet.status,
                            onDisconnect: () => _disconnect(context, wallet),
                          ),
                          const SizedBox(height: 14),
                        ],
                        const SizedBox(height: 6),

                        // Botón de Agregar Billetera
                        AddWalletButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
