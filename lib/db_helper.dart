import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'model/dog.dart';

final String TableName = 'Dog';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'MyDogsDB.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE $TableName (id INTEGER PRIMARY KEY, name TEXT)');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createData(Dog dog) async {
    final db = await database;
    var res = await db
        .rawInsert('INSERT INTO $TableName(name) VALUES(?)', [dog.name]);
    return res;
  }

  //Create
  createDataByName(String name) async {
    final db = await database;
    var res =
        await db.rawInsert('INSERT INTO $TableName(name) VALUES(?)', [name]);
    return res;
  }

  //Read
  getDog(int id) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName WHERE id = ?', [id]);
    return res.isNotEmpty
        ? Dog(id: res.first['id'], name: res.first['name'])
        : Null;
  }

  //Read All
  Future<List<Dog>> getAllDogs() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM $TableName');
    List<Dog> list = res.isNotEmpty
        ? res.map((c) => Dog(id: c['id'], name: c['name'])).toList()
        : [];

    return list;
  }

  //Update
  updateDog(Dog dog) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE $TableName SET name = ? WHERE = ?', [dog.name, dog.id]);
    return res;
  }

  //Delete
  deleteDog(int id) async {
    final db = await database;
    var res = db.rawDelete('DELETE FROM $TableName WHERE id = ?', [id]);
    return res;
  }

  //Delete All
  deleteAllDogs() async {
    final db = await database;
    db.rawDelete('DELETE FROM $TableName');
  }
}
