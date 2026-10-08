import 'package:flutter/material.dart';
import 'package:vitis/widgets/wallets/add_wallet_button.dart';
import 'package:vitis/widgets/wallets/wallet_card.dart';

class MyWalletsScreen extends StatelessWidget {
  const MyWalletsScreen({super.key});

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
          child: Column(
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
                '4 bancos sincronizados',
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 24),

              // Lista de cuentas
              Expanded(
                child: ListView(
                  children: [
                    const WalletCard(bankKey: "mp", title: "Mercado Pago"),
                    const SizedBox(height: 14),
                    const WalletCard(bankKey: "nx", title: "Naranja X"),
                    const SizedBox(height: 14),
                    const WalletCard(bankKey: "bn", title: "Banco Nación"),
                    const SizedBox(height: 14),
                    const WalletCard(bankKey: "lm", title: "LemonCash"),
                    const SizedBox(height: 20),

                    // Botón de Agregar Billetera
                    AddWalletButton(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
