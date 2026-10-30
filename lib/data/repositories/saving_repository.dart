import 'package:vitis/data/models/saving.dart';

abstract interface class SavingRepository {
  Future<List<Saving>> listForUser(String userId);

  // Devuelve el ahorro con su id asignado.
  Future<Saving> add(Saving saving);

  Future<void> update(Saving saving);
}

class MockSavingRepository implements SavingRepository {
  MockSavingRepository([List<Saving> seed = const []])
    : _savings = List.of(seed);

  final List<Saving> _savings;
  int _nextId = 1;

  @override
  Future<List<Saving>> listForUser(String userId) async =>
      _savings.where((saving) => saving.userId == userId).toList();

  @override
  Future<Saving> add(Saving saving) async {
    final saved = saving.copyWith(id: 'saving-${_nextId++}');
    _savings.add(saved);
    return saved;
  }

  @override
  Future<void> update(Saving saving) async {
    _savings[_savings.indexWhere((s) => s.id == saving.id)] = saving;
  }
}
