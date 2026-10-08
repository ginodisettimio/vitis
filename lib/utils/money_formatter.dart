import 'package:intl/intl.dart';

// Monto con el símbolo adelante, punto de miles y coma decimal: $ 45.230,50
// Patrón propio porque intl no trae datos de es_AR y cae en "es" (España),
// que pone el símbolo al final (45.230,50 $).
String formatearMonto(double monto, {int decimales = 2}) {
  return NumberFormat.currency(
    locale: 'es',
    symbol: '\$',
    decimalDigits: decimales,
    customPattern: '\u00A4\u00A0#,##0.00',
  ).format(monto);
}

// Igual que formatearMonto, con el signo pegado adelante:
// +$ 95.000,00 (ingreso) / -$ 4.250,00 (egreso).
String formatearMontoConSigno(double monto, {int decimales = 2}) {
  final signo = monto < 0 ? '-' : '+';
  return '$signo${formatearMonto(monto.abs(), decimales: decimales)}';
}

// Lee un monto escrito con punto de miles y coma decimal (ej: 1.500,50).
// Devuelve null si el texto no es un número.
double? parsearMonto(String texto) =>
    double.tryParse(texto.trim().replaceAll('.', '').replaceAll(',', '.'));
