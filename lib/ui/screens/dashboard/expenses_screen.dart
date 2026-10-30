import 'package:flutter/material.dart';
import 'package:vitis/data/models/category_spending.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/ui/widgets/feedback/empty_message.dart';
import 'package:vitis/utils/app_theme.dart';
import 'package:vitis/utils/date_formatter.dart';
import 'package:vitis/utils/money_formatter.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hoy = DateTime.now();
    final store = MovementsStore.instance;
    final categories = store.expensesByCategory;
    final highest = categories.isEmpty ? 0.0 : categories.first.amount;

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
              // Encabezado con botón de retroceso, título y subtítulo
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Gastos por Categoría',
                        style: Theme.of(context).textTheme.titleLarge
                            ?.copyWith(fontSize: 20),
                      ),
                      Text(
                        '${nombreMes(hoy.month)} ${hoy.year}',
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Contenido con scroll
              Expanded(
                child: categories.isEmpty
                    ? const EmptyMessage('Sin gastos este mes')
                    : ListView(
                        children: [
                          // Tarjeta Total Gastado
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryVariant,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: -20,
                                  top: -20,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'TOTAL GASTADO',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formatearMonto(store.totalExpenses),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${categories.length} ${categories.length == 1 ? 'categoría' : 'categorías'} · ${nombreMes(hoy.month).toLowerCase()}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.8,
                                        ),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tarjeta de Distribución (barras relativas a la categoría mayor)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Theme.of(context).highlightColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Distribución',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 160,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      for (final (i, c) in categories.indexed)
                                        Expanded(
                                          child: _buildBarItem(
                                            _shortLabel(c.label),
                                            c.amount / highest,
                                            AppTheme.categoryColor(i),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Tarjeta de Detalle por categoría
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardTheme.color,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Theme.of(context).highlightColor,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Detalle por categoría',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(height: 20),
                                for (final (i, c) in categories.indexed) ...[
                                  if (i > 0) const SizedBox(height: 18),
                                  _buildCategoryRow(i, c),
                                ],
                              ],
                            ),
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

  // 'Alimentación' -> 'Alim.', para que entre debajo de la barra.
  String _shortLabel(String label) =>
      label.length <= 5 ? label : '${label.substring(0, 4)}.';

  Widget _buildCategoryRow(int index, CategorySpending category) =>
      _buildDetailRow(
        color: AppTheme.categoryColor(index),
        title: category.label,
        amount: formatearMonto(category.amount),
        percentage: '${category.percentage.round()}%',
        progress: category.percentage / 100,
      );

  Widget _buildBarItem(String label, double heightFactor, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 22,
          height: 110 * heightFactor,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textGrey,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required Color color,
    required String title,
    required String amount,
    required String percentage,
    required double progress,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  amount,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  percentage,
                  style: const TextStyle(
                    color: AppTheme.textGrey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppTheme.inputLight,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
