import 'package:vitis/data/mock/mock_parsers.dart';
import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/saving.dart';
import 'package:vitis/data/models/transfer.dart';
import 'package:vitis/data/models/wallet.dart';

// Datos de prueba de la cuenta demo. Las fechas son relativas a hoy para que
// "Hoy" y "Ayer" sigan siendo ciertos.
const String demoUserId = 'user-demo';
const String demoEmail = 'demo@vitis.app';
const String demoPassword = 'demo1234';

// Segunda cuenta demo, con sus propios datos.
const String secondDemoUserId = 'user-demo-2';
const String secondDemoEmail = 'tomas@vitis.app';
const String secondDemoPassword = 'tomas1234';

DateTime _daysAgo(int days, int hour, int minute) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day - days, hour, minute);
}

const Wallet _mercadoPago = Wallet(
  id: 'demo-mp',
  userId: demoUserId,
  name: 'Mercado Pago',
  logo: '',
  providerKey: 'mp',
  balance: 45230.50,
  status: WalletStatus.connected,
);
const Wallet _naranjaX = Wallet(
  id: 'demo-nx',
  userId: demoUserId,
  name: 'Naranja X',
  logo: '',
  providerKey: 'nx',
  balance: 12850,
  status: WalletStatus.connected,
);
const Wallet _bancoNacion = Wallet(
  id: 'demo-bn',
  userId: demoUserId,
  name: 'Banco Nación',
  logo: '',
  providerKey: 'bn',
  balance: 989000,
  status: WalletStatus.connected,
);
const Wallet _lemon = Wallet(
  id: 'demo-lm',
  userId: demoUserId,
  name: 'LemonCash',
  logo: '',
  providerKey: 'lm',
  balance: 7320.75,
  status: WalletStatus.connected,
);
const Wallet _secondMercadoPago = Wallet(
  id: 'demo2-mp',
  userId: secondDemoUserId,
  name: 'Mercado Pago',
  logo: '',
  providerKey: 'mp',
  balance: 250000,
  status: WalletStatus.connected,
);
const Wallet _secondBancoNacion = Wallet(
  id: 'demo2-bn',
  userId: secondDemoUserId,
  name: 'Banco Nación',
  logo: '',
  providerKey: 'bn',
  balance: 1600000,
  status: WalletStatus.connected,
);

List<Wallet> demoWallets() => const [
  _mercadoPago,
  _naranjaX,
  _bancoNacion,
  _lemon,
  _secondMercadoPago,
  _secondBancoNacion,
];

List<Saving> demoSavings() => const [
  Saving(
    id: 'demo-trip',
    userId: demoUserId,
    name: 'Viaje a Bariloche',
    reserved: 45000,
    target: 150000,
    icon: 'barrel',
  ),
  Saving(
    id: 'demo-emergency',
    userId: demoUserId,
    name: 'Fondo de emergencia',
    reserved: 80000,
    target: 200000,
    icon: 'barrel',
  ),
  Saving(
    id: 'demo2-bike',
    userId: secondDemoUserId,
    name: 'Moto nueva',
    reserved: 60000,
    target: 400000,
    icon: 'barrel',
  ),
];

List<Cash> demoCash() => [
  Cash(
    id: 'demo-cash-1',
    userId: demoUserId,
    amount: 3000,
    type: MovementType.income,
    date: _daysAgo(2, 17, 10),
    note: 'Venta de ropa',
  ),
  Cash(
    id: 'demo-cash-2',
    userId: demoUserId,
    amount: 2000,
    type: MovementType.expense,
    date: _daysAgo(3, 11, 40),
    note: 'Verdulería',
  ),
  // Historial: cada mes se compensa, así no cambia el efectivo disponible.
  for (var month = 1; month <= 5; month++) ...[
    Cash(
      id: 'demo-cash-income-$month',
      userId: demoUserId,
      amount: 2500,
      type: MovementType.income,
      date: _daysAgo(31 * month - 8, 17, 30),
      note: 'Venta de usados',
    ),
    Cash(
      id: 'demo-cash-expense-$month',
      userId: demoUserId,
      amount: 2500,
      type: MovementType.expense,
      date: _daysAgo(31 * month - 14, 11, 0),
      note: 'Feria',
    ),
  ],
  Cash(
    id: 'demo2-cash-1',
    userId: secondDemoUserId,
    amount: 3500,
    type: MovementType.expense,
    date: _daysAgo(1, 13, 0),
    note: 'Almuerzo',
  ),
];

// Respuesta con el formato inventado de Mercado Pago y Lemon.
Map<String, Object?> _signedResponse(
  String description,
  double amount,
  DateTime date,
  String? category,
) => {
  'description': description,
  'amount': amount,
  'date': date.toUtc().toIso8601String(),
  'category': category,
};

// Respuesta con el formato inventado de Naranja X y Banco Nación.
Map<String, Object?> _nestedResponse(
  String concept,
  double amount,
  DateTime date,
  String? group,
) => {
  'data': {
    'concept': concept,
    'value': amount.abs().toStringAsFixed(2),
    'direction': amount < 0 ? 'DEBIT' : 'CREDIT',
    'ts': date.millisecondsSinceEpoch,
    'group': group,
  },
};

List<Transfer> demoTransfers() {
  registerMockParsers();
  return [
    (
      _mercadoPago,
      _signedResponse(
        'Supermercado Día',
        -4250,
        _daysAgo(0, 14, 30),
        'Alimentación',
      ),
    ),
    (
      _bancoNacion,
      _nestedResponse('Sueldo', 95000, _daysAgo(0, 9, 0), 'Ingresos'),
    ),
    (
      _naranjaX,
      _nestedResponse('Netflix', -2799, _daysAgo(1, 10, 15), 'Entretenimiento'),
    ),
    (
      _mercadoPago,
      _signedResponse('Carga SUBE', -1200, _daysAgo(1, 8, 45), 'Transporte'),
    ),
    (
      _lemon,
      _signedResponse(
        'Proyecto freelance',
        15000,
        _daysAgo(2, 18, 20),
        'Ingresos',
      ),
    ),
    (
      _mercadoPago,
      _signedResponse('Coto', -12750, _daysAgo(3, 19, 5), 'Alimentación'),
    ),
    (
      _mercadoPago,
      _signedResponse('Uber', -7300, _daysAgo(4, 22, 30), 'Transporte'),
    ),
    (
      _naranjaX,
      _nestedResponse('Cine', -2401, _daysAgo(5, 20, 0), 'Entretenimiento'),
    ),
    (
      _naranjaX,
      _nestedResponse('Edesur', -7000, _daysAgo(6, 12, 0), 'Servicios'),
    ),
    (
      _bancoNacion,
      _nestedResponse('Internet', -5000, _daysAgo(7, 9, 30), 'Servicios'),
    ),
    (
      _mercadoPago,
      _signedResponse('Carrefour', -15000, _daysAgo(8, 18, 45), 'Alimentación'),
    ),
    // Sin categoría: el banco no la informa y cae en la categoría por defecto.
    (
      _mercadoPago,
      _signedResponse('Farmacia Del Pueblo', -3400, _daysAgo(9, 16, 20), null),
    ),
    (_lemon, _signedResponse('Kiosco', -1900, _daysAgo(9, 13, 10), null)),
    // Historial: un ciclo cada 31 días, con el sueldo primero y el resto en los
    // días siguientes. Así ningún mes calendario junta dos sueldos.
    for (var month = 1; month <= 5; month++) ...[
      (
        _bancoNacion,
        _nestedResponse(
          'Sueldo',
          95000,
          _daysAgo(31 * month, 9, 0),
          'Ingresos',
        ),
      ),
      (
        _mercadoPago,
        _signedResponse(
          'Coto',
          -16000.0 + 700 * month,
          _daysAgo(31 * month - 3, 19, 10),
          'Alimentación',
        ),
      ),
      (
        _naranjaX,
        _nestedResponse(
          'Edesur',
          -6500.0 + 150 * month,
          _daysAgo(31 * month - 6, 12, 0),
          'Servicios',
        ),
      ),
      (
        _mercadoPago,
        _signedResponse(
          'Uber',
          -5200.0 + 200 * month,
          _daysAgo(31 * month - 9, 22, 15),
          'Transporte',
        ),
      ),
      (
        _naranjaX,
        _nestedResponse(
          'Netflix',
          -2799,
          _daysAgo(31 * month - 12, 10, 15),
          'Entretenimiento',
        ),
      ),
      (
        _bancoNacion,
        _nestedResponse(
          'Internet',
          -5000,
          _daysAgo(31 * month - 15, 9, 30),
          'Servicios',
        ),
      ),
      (
        _mercadoPago,
        _signedResponse(
          'Carrefour',
          -18500.0 + 500 * month,
          _daysAgo(31 * month - 18, 18, 40),
          'Alimentación',
        ),
      ),
      (
        _lemon,
        _signedResponse(
          'Proyecto freelance',
          30000.0 - 2000 * month,
          _daysAgo(31 * month - 21, 18, 20),
          'Ingresos',
        ),
      ),
    ],
    // Segunda cuenta demo.
    (
      _secondBancoNacion,
      _nestedResponse('Sueldo', 120000, _daysAgo(5, 9, 0), 'Ingresos'),
    ),
    (
      _secondMercadoPago,
      _signedResponse('Jumbo', -18300, _daysAgo(1, 19, 30), 'Alimentación'),
    ),
    (
      _secondMercadoPago,
      _signedResponse('Nafta', -22000, _daysAgo(3, 8, 20), 'Transporte'),
    ),
    (
      _secondBancoNacion,
      _nestedResponse('Spotify', -1999, _daysAgo(4, 10, 0), 'Entretenimiento'),
    ),
    for (var month = 1; month <= 3; month++) ...[
      (
        _secondBancoNacion,
        _nestedResponse(
          'Sueldo',
          120000,
          _daysAgo(31 * month + 5, 9, 0),
          'Ingresos',
        ),
      ),
      (
        _secondMercadoPago,
        _signedResponse(
          'Jumbo',
          -21000.0 + 600 * month,
          _daysAgo(31 * month - 10, 19, 0),
          'Alimentación',
        ),
      ),
      (
        _secondBancoNacion,
        _nestedResponse(
          'Metrogas',
          -8400.0 + 200 * month,
          _daysAgo(31 * month - 18, 11, 30),
          'Servicios',
        ),
      ),
    ],
  ].map((entry) => Transfer.fromResponse(entry.$1, entry.$2)).toList();
}
