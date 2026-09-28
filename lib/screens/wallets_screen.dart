import 'package:flutter/material.dart';
import 'package:vitis/screens/add_new_wallet_screen.dart';
import 'package:vitis/utils/app_theme.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título principal
              Text(
                'Mis cuentas',
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
                    _buildAccountCard(
                      context,
                      bankKey: 'mp',
                      title: 'Mercado Pago',
                    ),
                    const SizedBox(height: 14),
                    _buildAccountCard(
                      context,
                      bankKey: 'nx',
                      title: 'Naranja X',
                    ),
                    const SizedBox(height: 14),
                    _buildAccountCard(
                      context,
                      bankKey: 'bn',
                      title: 'Banco Nación',
                    ),
                    const SizedBox(height: 14),
                    _buildAccountCard(context, bankKey: 'lm', title: 'Lemon'),
                    const SizedBox(height: 20),

                    // Botón de Agregar Cuenta con borde punteado
                    _buildAddAccountButton(context),
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

  Widget _buildAccountCard(
    BuildContext context, {
    required String bankKey,
    required String title,
  }) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Logo / Icono del banco
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
              // Textos descriptivos
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
        ],
      ),
    );
  }

  Widget _buildAddAccountButton(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/addwallet");
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.4),
            width: 1.5,
            style: BorderStyle.values[1], // Simula borde punteado (o usar paquete dotted_border)
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: AppTheme.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Agregar cuenta',
              style: TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
