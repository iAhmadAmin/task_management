import 'package:sqflite/sqflite.dart';
import 'package:task_management/models/task.dart';

class DBHelper {
  static Database _db;
  static final int _version = 1;
  static final String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }
    try {
      String _path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db, version) {
          return db.execute(
            "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, title STRING, note TEXT)",
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async =>
      await _db.insert(_tableName, task.toJson());

  static Future<int> delete(Task task) async =>
      await _db.delete(_tableName, where: 'id = ?', whereArgs: [task.id]);

  static Future<List<Map<String, dynamic>>> query() async =>
      _db.query(_tableName);
}
