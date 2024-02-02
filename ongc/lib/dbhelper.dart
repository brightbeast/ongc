import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const dbName = "employee.db";
  static const version = 1;
  static const table = "myTable";

  static const columnId = "id";
  static const columnName = "Name";
  static const columnAge = "Age";
  static const columnCanteen = "Canteen";

  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory directory = await getApplicationCacheDirectory();
    // print("The location of the database is ${directory.path}");
    String path = join(directory.path, dbName);
    return await openDatabase(path, version: version, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(''' 
      CREATE TABLE $table(
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnAge INTEGER NOT NULL,
        $columnCanteen BIT NOT NULL
      )
      ''');
  }

  //Create
  Future<int> insertData(Map<String, dynamic> row) async {
    Database db = await getDatabase();
    return await db.insert(table, row);
  }

  //Read
  Future<List<Map<String, dynamic>>> readData() async {
    Database db = await getDatabase();
    return await db.query(table);
  }

  //Delete
  Future<int> deleteData(int id) async {
    Database db = await getDatabase();
    var res = await db.delete(table, where: "id= ?", whereArgs: [id]);
    return res;
  }
}
