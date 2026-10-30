import 'package:flutter/material.dart';

const List<String> _meses = [
  'Enero',
  'Febrero',
  'Marzo',
  'Abril',
  'Mayo',
  'Junio',
  'Julio',
  'Agosto',
  'Septiembre',
  'Octubre',
  'Noviembre',
  'Diciembre',
];

// Nombre del mes a partir de su número (1 = Enero ... 12 = Diciembre).
String nombreMes(int mes) {
  assert(mes >= 1 && mes <= 12, 'El mes tiene que estar entre 1 y 12');
  return _meses[mes - 1];
}

// 'Hoy', 'Ayer' o '26 ago', según la fecha local.
String dayLabel(DateTime date, {DateTime? now}) {
  final today = DateUtils.dateOnly(now ?? DateTime.now());
  final day = DateUtils.dateOnly(date);
  final difference = today.difference(day).inDays;
  if (difference == 0) return 'Hoy';
  if (difference == 1) return 'Ayer';
  return '${day.day} ${nombreMes(day.month).substring(0, 3).toLowerCase()}';
}

// Nombre del mes actual según la fecha del dispositivo.
String mesActual() => nombreMes(DateTime.now().month);
