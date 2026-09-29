import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:vitis/models/dashboard_models.dart';
import 'package:vitis/utils/app_theme.dart';

class CategorySpendingCard extends StatelessWidget {
  final List<CategorySpending> categories;

  const CategorySpendingCard({required this.categories, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.inputLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Gastos por Categoría',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontSize: 15, fontWeight: FontWeight.w800),
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
                              style: Theme.of(
                                context,
                              ).textTheme.bodyLarge?.copyWith(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '${c.percentage.round()}%',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(fontSize: 12, fontWeight: FontWeight.w700),
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
    );
  }
}
