import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/repositories/movement_repository.dart';
import 'package:vitis/data/repositories/wallet_repository.dart';
import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/movement_type.dart';
import 'package:vitis/data/models/transfer.dart';
import 'package:vitis/data/models/wallet.dart';
import 'package:vitis/data/states/movements_store.dart';

void main() {
  final now = DateTime.now();
  // 40 días atrás siempre cae en otro mes, sea cual sea la fecha de hoy.
  final lastMonth = now.subtract(const Duration(days: 40));

  Transfer transfer(
    String title,
    double amount,
    MovementType type,
    DateTime date,
    String category,
  ) => Transfer(
    userId: 'ana',
    walletId: 'w1',
    response: const {},
    title: title,
    amount: amount,
    type: type,
    date: date,
    category: category,
  );

  Cash cash(double amount, MovementType type, DateTime date, {String? note}) =>
      Cash(userId: 'ana', amount: amount, type: type, date: date, note: note);

  Future<MovementsStore> storeWith({
    List<Cash> cash = const [],
    List<Transfer> transfers = const [],
  }) async {
    final store = MovementsStore(
      MockMovementRepository(cash: cash, transfers: transfers),
      MockWalletRepository(const [
        Wallet(
          id: 'w1',
          userId: 'ana',
          name: 'Mercado Pago',
          logo: '',
          providerKey: 'mp',
          balance: 0,
        ),
      ]),
    );
    await store.load('ana');
    return store;
  }

  test('sorts newest first and names the source of each movement', () async {
    final store = await storeWith(
      cash: [cash(1, MovementType.income, lastMonth, note: 'Venta')],
      transfers: [transfer('Día', 5, MovementType.expense, now, 'Comida')],
    );

    expect(store.movements.map((m) => m.title), ['Día', 'Venta']);
    expect(store.movements.first.source, 'Mercado Pago');
    expect(store.movements.first.providerKey, 'mp');
    expect(store.movements.first.signedAmount, -5);
    expect(store.movements.last.source, 'Efectivo');
    expect(store.movements.last.providerKey, isNull);
  });

  test('recent is limited to the latest movements', () async {
    final store = await storeWith(
      cash: List.generate(8, (i) => cash(1, MovementType.income, now)),
    );

    expect(store.recent, hasLength(6));
  });

  test('cash without a note is titled Efectivo and counts as Otros', () async {
    final store = await storeWith(cash: [cash(10, MovementType.expense, now)]);

    expect(store.movements.single.title, 'Efectivo');
    expect(store.expensesByCategory.single.label, 'Otros');
  });

  test('netCash only counts cash, not transfers', () async {
    final store = await storeWith(
      cash: [
        cash(100, MovementType.income, now),
        cash(30, MovementType.expense, lastMonth),
      ],
      transfers: [
        transfer('Sueldo', 900, MovementType.income, now, 'Ingresos'),
      ],
    );

    expect(store.netCash, 70);
  });

  test('monthly expenses ignore income and other months', () async {
    final store = await storeWith(
      transfers: [
        transfer('Día', 75, MovementType.expense, now, 'Comida'),
        transfer('Coto', 25, MovementType.expense, now, 'Luz'),
        transfer('Viejo', 999, MovementType.expense, lastMonth, 'Comida'),
        transfer('Sueldo', 500, MovementType.income, now, 'Ingresos'),
      ],
    );

    final categories = store.expensesByCategory;
    expect(store.totalExpenses, 100);
    expect(categories.map((c) => c.label), ['Comida', 'Luz']);
    expect(categories.first.amount, 75);
    expect(categories.first.percentage, 75);
  });

  test('no expenses give no categories, without dividing by zero', () async {
    final store = await storeWith();

    expect(store.expensesByCategory, isEmpty);
    expect(store.totalExpenses, 0);
    expect(store.monthGrowthPercent(0), 0);
  });

  test('growth is the month net over the start of month balance', () async {
    final store = await storeWith(
      transfers: [
        transfer('Sueldo', 200, MovementType.income, now, 'Ingresos'),
        transfer('Día', 100, MovementType.expense, now, 'Comida'),
        transfer('Viejo', 999, MovementType.income, lastMonth, 'Ingresos'),
      ],
    );

    // Neto del mes: 100. Saldo al inicio: 1100 - 100 = 1000.
    expect(store.monthGrowthPercent(1100), 10);
    // El saldo inicial no es positivo: el porcentaje no tendría sentido.
    expect(store.monthGrowthPercent(50), 0);
  });

  test(
    'growth leaves out a disconnected wallet, but keeps its movements',
    () async {
      final store = MovementsStore(
        MockMovementRepository(
          cash: [cash(100, MovementType.income, now)],
          transfers: [
            transfer('Sueldo', 500, MovementType.income, now, 'Ingresos'),
          ],
        ),
        MockWalletRepository(const [
          Wallet(
            id: 'w1',
            userId: 'ana',
            name: 'Mercado Pago',
            logo: '',
            providerKey: 'mp',
            balance: 500,
            status: WalletStatus.disconnected,
          ),
        ]),
      );
      await store.load('ana');

      // Solo cuenta el efectivo: neto 100, saldo al inicio 1100 - 100 = 1000.
      expect(store.monthGrowthPercent(1100), 10);
      expect(store.movements, hasLength(2));
      expect(store.movements.map((m) => m.source), contains('Mercado Pago'));
    },
  );

  test('addCash updates list and net, and survives a reload', () async {
    final store = await storeWith();

    await store.addCash(amount: 40, type: MovementType.expense, note: 'Café');

    expect(store.movements.single.title, 'Café');
    expect(store.netCash, -40);
    await store.load('ana');
    expect(store.movements.single.title, 'Café');
    expect(store.netCash, -40);
  });
}
