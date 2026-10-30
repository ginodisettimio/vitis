import 'package:flutter/foundation.dart';
import 'package:vitis/data/states/document_store.dart';
import 'package:vitis/data/models/user.dart';

// Base de datos de la app. Hay que llamar a open() antes de usarla.
class AppDatabase {
  AppDatabase._();

  static final AppDatabase instance = AppDatabase._();

  static const String users = 'users';
  static const String wallets = 'wallets';
  static const String cash = 'cash';
  static const String savings = 'savings';
  static const String transfers = 'transfers';

  static const List<String> collections = [
    users,
    wallets,
    cash,
    savings,
    transfers,
  ];

  Future<void>? _opening;
  DocumentStore? _store;

  // Varias llamadas comparten la misma apertura. Si falla, se puede reintentar.
  Future<void> open({
    @visibleForTesting Future<DocumentStore> Function()? opener,
  }) => _opening ??= _open(
    opener ?? () => CouchbaseStore.open('vitis', collections),
  );

  Future<void> _open(Future<DocumentStore> Function() opener) async {
    try {
      _store = await opener();
    } catch (_) {
      _opening = null;
      rethrow;
    }
  }

  // Devuelve el id del documento. Con un id existente reemplaza el documento.
  Future<String> save(
    String collection,
    Map<String, Object?> data, {
    String? id,
  }) {
    _validateCollection(collection);
    return _opened.save(collection, data, id: id);
  }

  // El mapa devuelto incluye el id del documento en 'id'.
  Future<Map<String, Object?>?> get(String collection, String id) {
    _validateCollection(collection);
    return _opened.get(collection, id);
  }

  Future<List<Map<String, Object?>>> listForUser(
    String collection,
    String userId,
  ) {
    _validateCollection(collection); // el nombre va dentro del SQL
    return _queryDocuments(
      'SELECT META(c).id AS id, c AS doc FROM $collection AS c '
      r'WHERE c.userId = $userId',
      {'userId': userId},
    );
  }

  // No distingue mayúsculas: User guarda el correo normalizado. No se usa
  // LOWER() en la consulta porque devuelve null en las builds sin ICU (Linux).
  Future<Map<String, Object?>?> findUserByEmail(String email) async {
    final results = await _queryDocuments(
      'SELECT META(c).id AS id, c AS doc FROM $users AS c '
      r'WHERE c.email = $email LIMIT 1',
      {'email': User.normalizeEmail(email)},
    );
    return results.isEmpty ? null : results.first;
  }

  // Couchbase anida cada documento bajo su alias: se aplana a la forma de get().
  Future<List<Map<String, Object?>>> _queryDocuments(
    String sql,
    Map<String, Object?> parameters,
  ) async {
    final rows = await _opened.query(sql, parameters);
    return [
      for (final row in rows)
        {...row['doc'] as Map<String, Object?>, 'id': row['id']},
    ];
  }

  // No hace nada si el documento no existe.
  Future<void> delete(String collection, String id) {
    _validateCollection(collection);
    return _opened.delete(collection, id);
  }

  Future<void> close() async {
    final opening = _opening;
    if (opening == null) return;
    await opening;
    await _store!.close();
    _store = null;
    _opening = null;
  }

  DocumentStore get _opened =>
      _store ?? (throw StateError('The database is not open'));

  void _validateCollection(String name) {
    if (!collections.contains(name)) {
      throw ArgumentError('Unknown collection: $name');
    }
  }
}
