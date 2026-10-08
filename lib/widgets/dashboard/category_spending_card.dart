import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vitis/models/dashboard_models.dart';
import 'package:vitis/screens/dashboard/expenses_screen.dart';
import 'package:vitis/utils/app_theme.dart';

class CategorySpendingCard extends StatelessWidget {
  final List<CategorySpending> categories;

  /// Acción al tocar la tarjeta. Si es `null`, la tarjeta navega por sí sola
  /// a [ExpensesScreen].
  final VoidCallback? onTap;

  const CategorySpendingCard({required this.categories, this.onTap, super.key});

  void _openExpenses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const ExpensesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardTheme.color,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap ?? () => _openExpenses(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Theme.of(context).highlightColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gastos por Categoría',
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(fontSize: 15, fontWeight: FontWeight.w800),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppTheme.primary,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SizedBox(
                    height: 110,
                    width: 110,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 28,
                        sections: List.generate(categories.length, (i) {
                          return PieChartSectionData(
                            value: categories[i].percentage,
                            color: MockDashboardData.getCategoryColor(i),
                            showTitle: false,
                            radius: 22,
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(categories.length, (i) {
                        final c = categories[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: MockDashboardData.getCategoryColor(i),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  c.label,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${c.percentage.round()}%',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
