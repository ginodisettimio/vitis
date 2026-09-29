import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
              // Encabezado con botón de retroceso y título
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: theme.canvasColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                      color: AppTheme.primaryDark,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'Todos los movimientos',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Lista de movimientos agrupados por fecha
              Expanded(
                child: ListView(
                  children: [
                    // Sección: HOY
                    _buildSectionHeader('HOY'),
                    const SizedBox(height: 10),
                    _buildMovementCard(
                      context,
                      bankName: 'Mercado Pago',
                      bankColor: AppTheme.bankColors['mp'] ?? AppTheme.primary,
                      icon: Icons.shopping_cart_outlined,
                      title: 'Supermercado Día',
                      time: '14:30',
                      amount: '- \$ 4.250,00',
                      isPositive: false,
                    ),
                    const SizedBox(height: 12),
                    _buildMovementCard(
                      context,
                      bankName: 'Banco Nación',
                      bankColor: AppTheme.bankColors['bn'] ?? AppTheme.primary,
                      icon: Icons.work_outline_rounded,
                      title: 'Sueldo agosto',
                      time: '09:00',
                      amount: '+ \$ 95.000,00',
                      isPositive: true,
                    ),
                    const SizedBox(height: 20),

                    // Sección: AYER
                    _buildSectionHeader('AYER'),
                    const SizedBox(height: 10),
                    _buildMovementCard(
                      context,
                      bankName: 'Naranja X',
                      bankColor: AppTheme.bankColors['nx'] ?? AppTheme.primary,
                      icon: Icons.movie_outlined,
                      title: 'Netflix',
                      time: '10:15',
                      amount: '- \$ 2.799,00',
                      isPositive: false,
                    ),
                    const SizedBox(height: 12),
                    _buildMovementCard(
                      context,
                      bankName: 'Mercado Pago',
                      bankColor: AppTheme.bankColors['mp'] ?? AppTheme.primary,
                      icon: Icons.directions_bus_outlined,
                      title: 'Carga SUBE',
                      time: '08:45',
                      amount: '- \$ 1.200,00',
                      isPositive: false,
                    ),
                    const SizedBox(height: 20),

                    // Sección: 26 AGO
                    _buildSectionHeader('26 AGO'),
                    const SizedBox(height: 10),
                    _buildMovementCard(
                      context,
                      bankName: 'Lemon',
                      bankColor: AppTheme.bankColors['lm'] ?? AppTheme.primary,
                      icon: Icons.code_rounded,
                      title: 'Proyecto freelance',
                      time: '18:20',
                      amount: '+ \$ 45.000,00',
                      isPositive: true,
                    ),
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

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppTheme.primaryVariant,
        fontSize: 12,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildMovementCard(
    BuildContext context, {
    required String bankName,
    required Color bankColor,
    required IconData icon,
    required String title,
    required String time,
    required String amount,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).highlightColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banco emisor con punto indicador
          Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: bankColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                bankName,
                style: TextStyle(
                  color: bankColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Detalles del movimiento e importe
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppTheme.primarySoft,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: AppTheme.primaryVariant, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppTheme.textGrey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                amount,
                style: TextStyle(
                  color: isPositive ? AppTheme.success : AppTheme.error,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
