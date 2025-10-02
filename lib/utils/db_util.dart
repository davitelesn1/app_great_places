import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      // Garante a criação da tabela correta no primeiro uso
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
        );
      },
      // E garante que a tabela exista mesmo que o DB já tenha sido criado antes
      onOpen: (db) async {
        // Garante a existência da tabela com o esquema completo
        await db.execute(
          'CREATE TABLE IF NOT EXISTS places(id TEXT PRIMARY KEY, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)',
        );
        // Migração defensiva: adiciona colunas caso o app tenha criado a tabela antiga sem lat/lng/address
        try { await db.execute('ALTER TABLE places ADD COLUMN lat REAL'); } catch (_) {}
        try { await db.execute('ALTER TABLE places ADD COLUMN lng REAL'); } catch (_) {}
        try { await db.execute('ALTER TABLE places ADD COLUMN address TEXT'); } catch (_) {}
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.getDatabase();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.getDatabase();
    return db.query(table);
}

  static Future<int> delete(String table, String id) async {
    final db = await DbUtil.getDatabase();
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> update(String table, Map<String, Object?> data) async {
    final db = await DbUtil.getDatabase();
    final id = data['id'];
    if (id == null) {
      throw ArgumentError('update requires an id in the data map');
    }
    return db.update(
      table,
      data,
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }
}