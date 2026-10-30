import 'package:flutter/material.dart';
import 'package:vitis/data/repositories/repositories.dart';
import 'package:vitis/data/repositories/user_repository.dart';
import 'package:vitis/data/models/user.dart';
import 'package:vitis/data/models/wallet.dart';
import 'package:vitis/data/states/movements_store.dart';
import 'package:vitis/data/states/savings_store.dart';
import 'package:vitis/data/states/wallets_store.dart';

// Usuario con la sesión iniciada. También carga y vacía los datos de los demás
// stores, para que un usuario nunca vea los datos del anterior.
class SessionStore extends ChangeNotifier {
  SessionStore(this._users, this._wallets, this._savings, this._movements);

  static final SessionStore instance = SessionStore(
    userRepository,
    WalletsStore.instance,
    SavingsStore.instance,
    MovementsStore.instance,
  );

  final UserRepository _users;
  final WalletsStore _wallets;
  final SavingsStore _savings;
  final MovementsStore _movements;

  User? _currentUser;

  // null si no hay sesión iniciada.
  User? get currentUser => _currentUser;

  // Sin sesión o sin preferencia guardada, sigue al dispositivo.
  ThemeMode get themeMode =>
      ThemeMode.values.asNameMap()[_currentUser?.preference(
        Preference.theme,
      )] ??
      ThemeMode.system;

  double get balance => _wallets.totalBalance + _movements.netCash;

  // Lo que se puede gastar o reservar sin tocar lo apartado en ahorros.
  double get availableBalance => balance - _savings.totalReserved;

  // Devuelve false si el correo o la contraseña no coinciden.
  Future<bool> login(String email, String password) async {
    final user = await _users.login(email, password);
    if (user == null) return false;
    await Future.wait([
      _wallets.load(user.id!),
      _savings.load(user.id!),
      _movements.load(user.id!),
    ]);
    _currentUser = user;
    notifyListeners();
    return true;
  }

  // Devuelve false si el correo ya está registrado. No inicia la sesión.
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _users.register(
      name: name,
      email: email,
      password: password,
    );
    return user != null;
  }

  void logout() {
    _currentUser = null;
    _wallets.clear();
    _savings.clear();
    _movements.clear();
    notifyListeners();
  }

  // Solo cambia los datos que se pasan. Devuelve false si el correo ya es de otra
  // cuenta.
  Future<bool> updateProfile({String? name, String? email}) async {
    final updated = _currentUser!.copyWith(
      name: name,
      email: email == null ? null : User.normalizeEmail(email),
    );
    if (!await _users.update(updated)) return false;
    _currentUser = updated;
    notifyListeners();
    return true;
  }

  Future<void> setPreference(String key, String value) async {
    final updated = _currentUser!.withPreference(key, value);
    await _users.update(updated);
    _currentUser = updated;
    notifyListeners();
  }

  // Devuelve false si dejaría sin respaldo lo reservado en ahorros. Los
  // movimientos se recargan para que dejen de contar en el saldo, sin borrarse.
  Future<bool> disconnectWallet(Wallet wallet) async {
    if (wallet.balance > availableBalance) return false;
    await _wallets.disconnect(wallet);
    await _movements.load(_currentUser!.id!);
    return true;
  }

  Future<void> changePassword(String newPassword) =>
      _users.changePassword(_currentUser!.id!, newPassword);
}
