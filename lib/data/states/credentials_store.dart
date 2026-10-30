import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vitis/data/models/wallet.dart';

// Credenciales bancarias en el almacenamiento seguro del sistema
// (Keystore/Keychain), fuera de la base, que no está cifrada.
class CredentialsStore {
  CredentialsStore._(this._storage);

  @visibleForTesting
  CredentialsStore.withStorage(this._storage);

  static final CredentialsStore instance = CredentialsStore._(
    const FlutterSecureStorage(),
  );

  final FlutterSecureStorage _storage;

  String _key(String walletId) => 'wallet.$walletId';

  // Se escriben juntas en una sola clave para que nunca quede guardada solo una.
  Future<void> save(String walletId, WalletCredentials credentials) =>
      _storage.write(
        key: _key(walletId),
        value: jsonEncode({
          'apiKey': credentials.apiKey,
          'accessToken': credentials.accessToken,
        }),
      );

  Future<WalletCredentials?> read(String walletId) async {
    final value = await _storage.read(key: _key(walletId));
    if (value == null) return null;
    final map = jsonDecode(value) as Map<String, dynamic>;
    return WalletCredentials(
      apiKey: map['apiKey'] as String,
      accessToken: map['accessToken'] as String,
    );
  }

  Future<void> delete(String walletId) => _storage.delete(key: _key(walletId));
}
