import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vitis/data/models/movement.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/ui/widgets/feedback/empty_message.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/utils/date_formatter.dart';
import 'package:vitis/utils/money_formatter.dart';

class MovementsScreen extends StatelessWidget {
  const MovementsScreen({super.key});

  static const Map<String, IconData> _categoryIcons = {
    'Alimentación': Icons.shopping_cart_outlined,
    'Transporte': Icons.directions_bus_outlined,
    'Entretenimiento': Icons.movie_outlined,
    'Servicios': Icons.bolt_outlined,
    'Ingresos': Icons.work_outline_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final movements = MovementsStore.instance.movements;

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
                child: movements.isEmpty
                    ? const EmptyMessage('Todavía no hay movimientos')
                    : ListView(children: _buildGroups(context, movements)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // La lista viene ordenada por fecha: un encabezado cada vez que cambia el día.
  List<Widget> _buildGroups(BuildContext context, List<Movement> movements) {
    final timeFormat = DateFormat('HH:mm');
    final children = <Widget>[];
    String? currentDay;
    for (final movement in movements) {
      final day = dayLabel(movement.date).toUpperCase();
      if (day != currentDay) {
        if (currentDay != null) children.add(const SizedBox(height: 8));
        children
          ..add(_buildSectionHeader(day))
          ..add(const SizedBox(height: 10));
        currentDay = day;
      }
      children
        ..add(
          _buildMovementCard(
            context,
            bankName: movement.source,
            bankColor:
                AppTheme.bankColors[movement.providerKey] ?? AppTheme.primary,
            icon: _categoryIcons[movement.category] ?? Icons.receipt_long,
            title: movement.title,
            time: timeFormat.format(movement.date),
            amount: movement.signedAmount,
          ),
        )
        ..add(const SizedBox(height: 12));
    }
    return children;
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
    required double amount, // positivo = ingreso, negativo = egreso
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
          // El título ocupa el espacio libre (con "..." si no entra), así el
          // importe nunca se sale de la tarjeta.
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(fontSize: 15, fontWeight: FontWeight.w800),
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
              ),
              const SizedBox(width: 8),
              Text(
                formatearMontoConSigno(amount),
                style: TextStyle(
                  color: amount >= 0 ? AppTheme.success : AppTheme.error,
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
