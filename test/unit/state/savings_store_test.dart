import 'package:flutter_test/flutter_test.dart';
import 'package:vitis/data/repositories/saving_repository.dart';
import 'package:vitis/data/models/saving.dart';
import 'package:vitis/data/states/savings_store.dart';

void main() {
  const saving = Saving(
    id: 's1',
    userId: 'ana',
    name: 'Viaje',
    reserved: 40,
    target: 100,
    icon: 'barrel',
  );
  late MockSavingRepository repository;
  late SavingsStore store;

  setUp(() async {
    repository = MockSavingRepository([saving]);
    store = SavingsStore(repository);
    await store.load('ana');
  });

  test('deposit adds to the reserve and saves it', () async {
    await store.deposit('s1', 10);

    expect(store.savings.single.reserved, 50);
    expect((await repository.listForUser('ana')).single.reserved, 50);
  });

  test('deposit never goes past the target', () async {
    await store.deposit('s1', 500);

    expect(store.savings.single.reserved, 100);
  });

  test('withdraw never goes below zero', () async {
    await store.withdraw('s1', 500);

    expect(store.savings.single.reserved, 0);
  });

  test('add includes the new saving in the total', () async {
    await store.add(name: 'Casa', reserved: 60, target: 1000);

    expect(store.savings, hasLength(2));
    expect(store.totalReserved, 100);
    expect(store.savings.last.id, isNot('s1'));
  });
}
