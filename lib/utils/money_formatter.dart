// Formato simple con separador de miles con punto y coma decimal: $ 45.000,00
String formatearMonto(double monto) {
  final str = monto.toInt().toString();
  final buffer = StringBuffer();
  for (int i = 0; i < str.length; i++) {
    if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
    buffer.write(str[i]);
  }
  return '\$ $buffer,00';
}
