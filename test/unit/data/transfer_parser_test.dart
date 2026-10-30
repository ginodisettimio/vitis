import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/parsers/transfer_parser.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/transfer.dart';
import 'package:vitis/data/models/wallet.dart';

// Formatos inventados: el signo da el tipo y la fecha viene en ISO.
class BankAParser implements TransferParser {
  @override
  TransferData parse(Map<String, Object?> response) {
    final amount = response['amount'];
    final date = response['date'];
    if (amount is! num || date is! String) {
      throw const FormatException('Invalid BankA response');
    }
    return TransferData(
      title: response['title'] as String? ?? '',
      amount: amount.abs().toDouble(),
      type: amount < 0 ? MovementType.expense : MovementType.income,
      date: DateTime.parse(date),
      category: response['category'] as String?,
    );
  }
}

// Datos anidados, el tipo es un texto y la fecha viene en milisegundos.
class BankBParser implements TransferParser {
  @override
  TransferData parse(Map<String, Object?> response) {
    final data = response['data'] as Map<String, Object?>;
    return TransferData(
      title: data['concept'] as String? ?? '',
      amount: double.parse(data['value'] as String),
      type: data['direction'] == 'CREDIT'
          ? MovementType.income
          : MovementType.expense,
      date: DateTime.fromMillisecondsSinceEpoch(data['ts'] as int, isUtc: true),
      category: data['group'] as String?,
    );
  }
}

void main() {
  const bankA = Wallet(
    id: 'w1',
    userId: 'u1',
    name: 'BankA',
    logo: 'a.png',
    providerKey: 'a',
    balance: 0,
  );
  const bankB = Wallet(
    id: 'w2',
    userId: 'u2',
    name: 'BankB',
    logo: 'b.png',
    providerKey: 'b',
    balance: 0,
  );
  final date = DateTime.utc(2026, 8, 26, 12);

  setUp(() {
    parsersByProvider
      ..clear()
      ..['a'] = BankAParser()
      ..['b'] = BankBParser();
  });

  tearDown(parsersByProvider.clear);

  test('two different formats give the same data', () {
    final a = Transfer.fromResponse(bankA, {
      'title': 'Luz',
      'amount': -1500.5,
      'date': date.toIso8601String(),
      'category': 'Services',
    });
    final b = Transfer.fromResponse(bankB, {
      'data': {
        'concept': 'Luz',
        'value': '1500.50',
        'direction': 'DEBIT',
        'ts': date.millisecondsSinceEpoch,
        'group': 'Services',
      },
    });

    for (final transfer in [a, b]) {
      expect(transfer.title, 'Luz');
      expect(transfer.amount, 1500.5);
      expect(transfer.type, MovementType.expense);
      expect(transfer.date, date);
      expect(transfer.category, 'Services');
    }
  });

  test('takes user and wallet from the wallet and keeps the response', () {
    final response = {'amount': 10, 'date': date.toIso8601String()};

    final transfer = Transfer.fromResponse(bankA, response);

    expect(transfer.userId, 'u1');
    expect(transfer.walletId, 'w1');
    expect(transfer.response, response);
  });

  test('uses the default category when missing', () {
    final transfer = Transfer.fromResponse(bankA, {
      'amount': 10,
      'date': date.toIso8601String(),
    });

    expect(transfer.category, Transfer.defaultCategory);
  });

  test('wallet without a parser throws StateError', () {
    const other = Wallet(
      id: 'w3',
      userId: 'u1',
      name: 'Other',
      logo: '',
      providerKey: 'other',
      balance: 0,
    );

    expect(() => Transfer.fromResponse(other, {}), throwsStateError);
  });

  test('unsaved wallet throws StateError', () {
    const unsaved = Wallet(
      userId: 'u1',
      name: 'BankA',
      logo: '',
      providerKey: 'a',
      balance: 0,
    );

    expect(() => Transfer.fromResponse(unsaved, {}), throwsStateError);
  });

  test('malformed response throws FormatException', () {
    expect(
      () => Transfer.fromResponse(bankA, {'amount': 'abc'}),
      throwsFormatException,
    );
  });
}
