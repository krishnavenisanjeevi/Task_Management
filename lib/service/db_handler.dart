// lib/services/db_helper.dart
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/task_model.dart';


class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  static Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE tasks (
          id INTEGER PRIMARY KEY,
          userId INTEGER,
          title TEXT,
          completed INTEGER,
          description TEXT,
          dueDate TEXT,
          priority TEXT,
          status TEXT,
          assignedUserId INTEGER
        )
      ''');
      // create indexes for performance
      await db.execute('CREATE INDEX idx_tasks_dueDate ON tasks(dueDate)');
      await db.execute('CREATE INDEX idx_tasks_status ON tasks(status)');
    });
  }

  static Future<void> addTask(Task task) async {
    final db = await database;
    await db.insert('tasks', task.toDb(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Task>> getTasks({int offset = 0, int limit = 20}) async {
    final db = await database;
    final maps = await db.query('tasks',
        orderBy: 'dueDate IS NULL, dueDate ASC, id ASC',
        limit: limit,
        offset: offset);
    return maps.map((m) => Task.fromDb(m)).toList();
  }

  static Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update('tasks', task.toDb(), where: 'id = ?', whereArgs: [task.id]);
  }

  static Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> getCount() async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) as c FROM tasks');
    return Sqflite.firstIntValue(res) ?? 0;
  }
}
