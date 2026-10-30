import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:vitis/data/repositories/repositories.dart';
import 'package:vitis/data/repositories/saving_repository.dart';
import 'package:vitis/data/models/saving.dart';

// Ahorros del usuario actual. Las pantallas la escuchan con ListenableBuilder.
class SavingsStore extends ChangeNotifier {
  SavingsStore(this._repository);

  static final SavingsStore instance = SavingsStore(savingRepository);

  final SavingRepository _repository;
  String? _userId;
  List<Saving> _savings = [];

  List<Saving> get savings => List.unmodifiable(_savings);

  double get totalReserved =>
      _savings.fold(0, (sum, saving) => sum + saving.reserved);

  Future<void> load(String userId) async {
    _userId = userId;
    _savings = await _repository.listForUser(userId);
    notifyListeners();
  }

  void clear() {
    _userId = null;
    _savings = [];
    notifyListeners();
  }

  Future<void> add({
    required String name,
    required double reserved,
    required double target,
  }) async {
    final saved = await _repository.add(
      Saving(
        userId: _userId!,
        name: name,
        reserved: reserved,
        target: target,
        icon: 'barrel',
      ),
    );
    _savings = [..._savings, saved];
    notifyListeners();
  }

  // Nunca pasa de la meta: deposita como mucho lo que falta.
  Future<void> deposit(String savingId, double amount) {
    final saving = _find(savingId);
    return _setReserved(
      saving,
      saving.reserved + math.min(amount, saving.remaining),
    );
  }

  // Nunca deja el ahorro en negativo: retira como mucho lo que hay.
  Future<void> withdraw(String savingId, double amount) {
    final saving = _find(savingId);
    return _setReserved(saving, math.max(0.0, saving.reserved - amount));
  }

  Saving _find(String savingId) => _savings.firstWhere((s) => s.id == savingId);

  Future<void> _setReserved(Saving saving, double reserved) async {
    final updated = saving.copyWith(reserved: reserved);
    await _repository.update(updated);
    _savings = [
      for (final s in _savings)
        if (s.id == updated.id) updated else s,
    ];
    notifyListeners();
  }
}
