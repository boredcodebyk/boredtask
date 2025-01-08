import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../model/task.dart';

class DBhelper {
  static DBhelper instance = DBhelper._();
  static Database? _db;
  static const int _version = 1;
  static const String tasksTable = 'tasks';
  static const String notesTable = 'notes';
  DBhelper._();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    if (_db != null) return _db!;

    String dbPath = path.join(await getDatabasesPath(), 'boredtask.db');
    if (kDebugMode) {
      print("Creating database");
    }
    var db = await openDatabase(
      dbPath,
      version: _version,
      onCreate: (db, version) async {
        await db.transaction((txn) async {
          await txn.execute("""
                CREATE TABLE $tasksTable (
                  id TEXT PRIMARY KEY, 
                  task TEXT, 
                  dateCreated TEXT, 
                  dateModified TEXT, 
                  priority INTEGER, 
                  contextTags TEXT, 
                  projectTags TEXT, 
                  due TEXT, 
                  done INTEGER,
                  pin INTEGER,
                  trash INTEGER,
                )
              """);
          await txn.execute("""
                CREATE TABLE $notesTable (
                  id TEXT PRIMARY KEY, 
                  note TEXT, 
                  dateCreated TEXT, 
                  dateModified TEXT)
              """);
        });
      },
    );
    return db;
  }

  Future<void> insertTask(Task task) async {
    final db = await instance.database;
    await db.insert(tasksTable, task.toJson());
  }

  Future<List<Task>> queryTask() async {
    final db = await instance.database;
    var rawList = await db.query(tasksTable);
    var list = rawList.map((e) => Task.fromJson(e)).toList();
    return list;
  }

  Future<List<Map<String, dynamic>>> rawQueryTask() async {
    final db = await instance.database;
    var list = await db.query(tasksTable);

    return list;
  }

  void deleteTask(Task task) async {
    final db = await instance.database;
    await db.delete(tasksTable, where: "id=?", whereArgs: [task.id]);
  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database;
    return await db.update(tasksTable, task.toJson(),
        where: 'id = ?', whereArgs: [task.id]);
  }
}
