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

// Nombre del mes actual según la fecha del dispositivo.
String mesActual() => nombreMes(DateTime.now().month);
