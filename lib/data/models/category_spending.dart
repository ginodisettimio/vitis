// Gasto agrupado por categoría. El color se asigna por índice con
// AppTheme.categoryColor.
class CategorySpending {
  final String label;
  final double amount;
  final double percentage; // de 0 a 100

  const CategorySpending({
    required this.label,
    required this.amount,
    required this.percentage,
  });
}
