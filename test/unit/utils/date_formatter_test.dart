import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/utils/date_formatter.dart';

void main() {
  final now = DateTime(2026, 3, 1, 10);

  test('today and yesterday use words, whatever the hour', () {
    expect(dayLabel(DateTime(2026, 3, 1, 0, 5), now: now), 'Hoy');
    expect(dayLabel(DateTime(2026, 2, 28, 23, 59), now: now), 'Ayer');
  });

  test('older days use day and short month', () {
    expect(dayLabel(DateTime(2026, 2, 26, 12), now: now), '26 feb');
  });
}
