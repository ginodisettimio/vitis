import 'package:flutter/material.dart';
import 'package:vitis/utils/app_theme.dart';

/// Una meta de ahorro con su progreso actual.
class SavingGoal {
  final String name;
  final double current;
  final double target;

  const SavingGoal({
    required this.name,
    required this.current,
    required this.target,
  });

  double get progress => target == 0 ? 0 : (current / target).clamp(0, 1);
}

/// Un gasto agrupado por categoría, para el gráfico de torta.
/// El color se asigna por índice contra AppTheme.pieColors.
class CategorySpending {
  final String label;
  final double percentage;

  const CategorySpending({required this.label, required this.percentage});
}

/// Un movimiento (ingreso o egreso) reciente.
class Transaction {
  final String title;
  final String date;
  final double amount; // positivo = ingreso, negativo = egreso

  const Transaction({
    required this.title,
    required this.date,
    required this.amount,
  });

  bool get isIncome => amount >= 0;
}

/// Datos de ejemplo (mock) para poder mostrar el dashboard mientras
/// no está conectado el backend / la sincronización bancaria real.
class MockDashboardData {
  static const double availableBalance = 30401.25;
  static const double reservedInSavings = 125000.00;
  static const double monthGrowthPercent = 12.9;

  static const List<SavingGoal> savingGoals = [
    SavingGoal(name: 'Viaje a Bariloche', current: 45000, target: 150000),
    SavingGoal(name: 'Fondo de emergencia', current: 80000, target: 200000),
  ];

  // bankKey coincide con AppTheme.bankColors ('mp', 'nx', 'bn', 'lm').
  static const Map<String, double> accountBalances = {
    'mp': 45230.50,
    'nx': 12850.00,
    'bn': 89000.00,
  };

  static const List<CategorySpending> categorySpending = [
    CategorySpending(label: 'Alimentación', percentage: 49),
    CategorySpending(label: 'Transporte', percentage: 15),
    CategorySpending(label: 'Entretenimiento', percentage: 8),
    CategorySpending(label: 'Servicios', percentage: 18),
    CategorySpending(label: 'Otros', percentage: 11),
  ];

  static const List<Transaction> recentTransactions = [
    Transaction(title: 'Supermercado Día', date: 'Hoy', amount: -4250),
    Transaction(title: 'Sueldo agosto', date: 'Hoy', amount: 95000),
    Transaction(title: 'Netflix', date: 'Ayer', amount: -2799),
    Transaction(title: 'Carga SUBE', date: 'Ayer', amount: -1200),
    Transaction(title: 'Proyecto freelance', date: '26 ago', amount: 45000),
    Transaction(title: 'Farmacia Del Pueblo', date: '25 ago', amount: -3400),
  ];

  /// Color de una categoría, tomado de AppTheme.pieColors por índice
  /// (con wraparound si hay más categorías que colores).
  static Color getCategoryColor(int index) {
    return AppTheme.pieColors[index % AppTheme.pieColors.length];
  }
}
