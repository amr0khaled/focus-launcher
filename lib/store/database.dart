import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

typedef Migration = Future<void> Function(Database db);

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();
  factory DatabaseManager() => _instance;
  DatabaseManager._internal();
  Database? _db;
  bool _initialized = false;

  final List<String> _tableSchemas = [];
  final Map<int, List<Migration>> _migrations = {};
  final List<String> _indexStatements = [];

  Future<Database> init({
    required String dbName,
    required int version,
  }) async {
    if (_db != null) return _db!;
    if (_initialized) throw StateError("Database already initialized");

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    _db = await openDatabase(
      path,
      version: version,
      onCreate: (db, v) async {
        // Fresh install: create all registered tables & indexes
        for (final schema in _tableSchemas) {
          if (schema.trim().startsWith('CREATE')) {
            await db.execute(schema);
          } else {
            var sql = await rootBundle.loadString(schema);
            await db.execute(sql);
          }
        }
        for (final schema in _indexStatements) {
          if (schema.trim().startsWith('CREATE')) {
            await db.execute(schema);
          } else {
            var sql = await rootBundle.loadString(schema);
            await db.execute(sql);
          }
        }
      },
      onUpgrade: (db, oldV, newV) async {
        // Apply migrations in order: oldV+1 -> newV
        for (int v = oldV + 1; v <= newV; v++) {
          final steps = _migrations[v];
          if (steps != null) {
            for (final step in steps) {
              await step(db);
            }
          }
        }
      },
    );

    _initialized = true;
    return _db!;
  }

  Database get db {
    if (_db == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    return _db!;
  }

  /// Register CREATE TABLE ... (optional).
  /// Call BEFORE init().
  void registerTable(String schema, {bool isAsset = false}) {
    _assertNotInitialized();
    _tableSchemas.add(schema);
  }

  /// Add a migration that runs when upgrading.
  /// Call BEFORE init().
  void registerMigration(int toVersion, Migration migration) {
    _assertNotInitialized();
    _migrations.putIfAbsent(toVersion, () => []).add(migration);
  }

  /// Register CREATE INDEX ... (optional).
  /// Call BEFORE init().
  void registerIndex(String createIndexSql, {bool isAsset = false}) {
    _assertNotInitialized();
    _indexStatements.add(createIndexSql);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
    _initialized = false;
  }

  Future<T> transaction<T>(Future<T> Function(Transaction txn) action) async {
    return db.transaction(action);
  }

  void _assertNotInitialized() {
    if (_initialized || _db != null) {
      throw StateError('Database already initialized; register before init().');
    }
  }
}

final databaseManagerProvider = Provider<DatabaseManager>((ref) {
  throw UnimplementedError();
});
