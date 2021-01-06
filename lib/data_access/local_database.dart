import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:starwars_live/model/person.dart';

class StarWarsDb {
  final Future<Database> database = _createDatabase();

  static Future<Database> _createDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    return getDatabasesPath().then((databasesPath) => openDatabase(
        join(databasesPath, 'starwars_live.db'),
        version: 1,
        onCreate: _createTables));
  }

  static void _createTables(Database database, int version) async {
    await database.execute("CREATE TABLE Person ("
        "id INTEGER PRIMARY KEY,"
        "first_name TEXT,"
        "last_name TEXT"
        ")");
  }

  Future<int> createPerson(Person person) async {
    final Database db = await database;
    var result = await db.insert("Person", person.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<Person>> getAllPersons() async {
    final Database db = await database;
    var result =
        await db.query("Person", columns: ["id", "first_name", "last_name"]);
    return result
        .toList(growable: false)
        .map((jsonPerson) => Person.fromJson(jsonPerson))
        .toList(growable: false);
  }

  Future<Person> getPersonById(int id) async {
    final Database db = await database;
    List<Map> results = await db.query("Person",
        columns: ["id", "first_name", "last_name"],
        where: 'id = ?',
        whereArgs: [id]);

    if (results.length > 0) return new Person.fromJson(results.first);
    return null;
  }

  Future<int> updatePerson(Person person) async {
    final Database db = await database;
    return await db.update("Person", person.toJson(),
        where: "id = ?", whereArgs: [person.id]);
  }

  Future<int> deletePerson(int id) async {
    final Database db = await database;
    return await db.delete("Person", where: 'id = ?', whereArgs: [id]);
  }

  Future<void> closeDatabase() async {
    final Database db = await database;
    await db.close();
  }
}
