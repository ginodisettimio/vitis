import 'package:vitis/data/models/cash.dart';
import 'package:vitis/data/models/transfer.dart';

abstract interface class MovementRepository {
  Future<List<Cash>> cashForUser(String userId);
  Future<List<Transfer>> transfersForUser(String userId);

  // Devuelve el registro con su id asignado.
  Future<Cash> addCash(Cash cash);
}

class MockMovementRepository implements MovementRepository {
  MockMovementRepository({
    List<Cash> cash = const [],
    List<Transfer> transfers = const [],
  }) : _cash = List.of(cash),
       _transfers = List.of(transfers);

  final List<Cash> _cash;
  final List<Transfer> _transfers;
  int _nextId = 1;

  @override
  Future<List<Cash>> cashForUser(String userId) async =>
      _cash.where((cash) => cash.userId == userId).toList();

  @override
  Future<List<Transfer>> transfersForUser(String userId) async =>
      _transfers.where((transfer) => transfer.userId == userId).toList();

  @override
  Future<Cash> addCash(Cash cash) async {
    final saved = cash.copyWith(id: 'cash-${_nextId++}');
    _cash.add(saved);
    return saved;
  }
}
