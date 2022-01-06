import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project_3_todo_local/model/task.dart';

class DatabaseHelper {
  static final _databaseName = 'MyDatabase.db';
  static final _databaseVersion = 1;
  static final table = 'taskTable';
  static final columnId = '_id';
  static final columnName = 'name';
  static final columnDetails = 'details';

  // we will make this is a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();

    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY,
          $columnName TEXT NOT NULL,
          $columnDetails TEXT
        )
      ''');
  }

  // add data to the database

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> deleteTask (String name) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnName = ?', whereArgs: [name]);
  }

}
