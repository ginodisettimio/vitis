import 'package:cbl/cbl.dart';
import 'package:cbl_flutter/cbl_flutter.dart';

// Operaciones que AppDatabase necesita del motor, solo con mapas: MutableDocument
// y Parameters son clases final que requieren la librería nativa, así que no se
// pueden mockear en tests unitarios.
abstract interface class DocumentStore {
  Future<String> save(
    String collection,
    Map<String, Object?> data, {
    String? id,
  });
  Future<Map<String, Object?>?> get(String collection, String id);
  Future<List<Map<String, Object?>>> query(
    String sql,
    Map<String, Object?> parameters,
  );
  Future<void> delete(String collection, String id);
  Future<void> close();
}

class CouchbaseStore implements DocumentStore {
  CouchbaseStore._(this._db, this._collections);

  final Database _db;
  final Map<String, Collection> _collections;

  // directory null usa la carpeta por defecto de la app.
  static Future<CouchbaseStore> open(
    String name,
    List<String> collections, {
    String? directory,
  }) async {
    await CouchbaseLiteFlutter.init();
    final db = await Database.openAsync(
      name,
      DatabaseConfiguration(directory: directory),
    );
    return CouchbaseStore._(db, {
      for (final collection in collections)
        collection: await db.createCollection(collection),
    });
  }

  @override
  Future<String> save(
    String collection,
    Map<String, Object?> data, {
    String? id,
  }) async {
    final document = id == null
        ? MutableDocument(data)
        : MutableDocument.withId(id, data);
    await _collections[collection]!.saveDocument(document);
    return document.id;
  }

  @override
  Future<Map<String, Object?>?> get(String collection, String id) async {
    final document = await _collections[collection]!.document(id);
    if (document == null) return null;
    return {...document.toPlainMap(), 'id': document.id};
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String sql,
    Map<String, Object?> parameters,
  ) async {
    final query = await _db.createQuery(sql);
    await query.setParameters(Parameters(parameters));
    final resultSet = await query.execute();
    final rows = await resultSet.allResults();
    return rows.map((row) => row.toPlainMap()).toList();
  }

  // No hace nada si el documento no existe.
  @override
  Future<void> delete(String collection, String id) async {
    final target = _collections[collection]!;
    final document = await target.document(id);
    if (document != null) await target.deleteDocument(document);
  }

  @override
  Future<void> close() => _db.close();
}
