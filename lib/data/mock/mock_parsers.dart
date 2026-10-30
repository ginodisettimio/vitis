import 'package:vitis/data/parsers/transfer_parser.dart';
import 'package:vitis/data/models/movement_type.dart';

// Formatos inventados: simulan que cada banco responde distinto.

// El signo del monto da el tipo y la fecha viene en ISO.
class _SignedAmountParser implements TransferParser {
  @override
  TransferData parse(Map<String, Object?> response) {
    final amount = response['amount'];
    final date = response['date'];
    final description = response['description'];
    if (amount is! num || date is! String || description is! String) {
      throw const FormatException('Invalid response');
    }
    return TransferData(
      title: description,
      amount: amount.abs().toDouble(),
      type: amount < 0 ? MovementType.expense : MovementType.income,
      date: DateTime.parse(date),
      category: response['category'] as String?,
    );
  }
}

// Datos anidados, el importe es texto y la fecha viene en milisegundos.
class _NestedParser implements TransferParser {
  @override
  TransferData parse(Map<String, Object?> response) {
    final data = response['data'];
    if (data is! Map<String, Object?>) {
      throw const FormatException('Invalid response');
    }
    final concept = data['concept'];
    final value = data['value'];
    final ts = data['ts'];
    if (concept is! String || value is! String || ts is! int) {
      throw const FormatException('Invalid response');
    }
    return TransferData(
      title: concept,
      amount: double.parse(value),
      type: data['direction'] == 'CREDIT'
          ? MovementType.income
          : MovementType.expense,
      date: DateTime.fromMillisecondsSinceEpoch(ts, isUtc: true),
      category: data['group'] as String?,
    );
  }
}

void registerMockParsers() {
  parsersByProvider
    ..['mp'] = _SignedAmountParser()
    ..['lm'] = _SignedAmountParser()
    ..['nx'] = _NestedParser()
    ..['bn'] = _NestedParser();
}
