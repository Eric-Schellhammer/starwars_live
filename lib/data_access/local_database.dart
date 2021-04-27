import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';

class StarWarsDb {
  static const int _version = 11;
  static final List<DbTable> _tables = [AccountTable(), PersonTable(), DocumentTable()];

  static Map<DbTableKey, DbTable>? _tablesByKey;
  final Future<Database> _database = _createDatabase();

  static Future<Database> _createDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    _ensureTablesMapIsFilled();
    return getDatabasesPath().then((databasesPath) => openDatabase(join(databasesPath, 'starwars_live.db'), version: _version, onUpgrade: _createTables));
  }

  static void _ensureTablesMapIsFilled() {
    if (_tablesByKey == null) {
      // TODO make synchronized
      _tablesByKey = Map();
      _tables.forEach((table) => _tablesByKey!.putIfAbsent(table.getDbTableKey(), () => table));
    }
  }

  static void _createTables(Database database, int oldVersion, int version) async {
    _tables.forEach((table) async {
      await database.execute("DROP TABLE IF EXISTS " + table.getDbTableKey().getTableName()); // TODO remove when total re-create is no longer desired
      await database.execute(table.createTableCommand());
      _tablesByKey!.putIfAbsent(table.getDbTableKey(), () => table);
    });
  }

  Future<int> insert(DbEntry entry) async => _database.then((db) => _tablesByKey![entry.getKey().getDbTableKey()]!.insert(db, entry));

  Future<int> update(DbEntry entry) async => _database.then((db) => _tablesByKey![entry.getKey().getDbTableKey()]!.update(db, entry));

  Future<int> delete(DbEntryKey id) async => _database.then((db) => _tablesByKey![id.getDbTableKey()]!.delete(db, id));

  Future<List<DB_ENTRY>> getAll<DB_ENTRY extends DbEntry>(DbTableKey<DB_ENTRY> table) async =>
      _database.then((db) => _tablesByKey![table]!.getAll(db)).then((list) => list as List<DB_ENTRY>);

  Future<DB_ENTRY> getById<DB_ENTRY extends DbEntry>(DbEntryKey key) async =>
      _database.then((db) => _tablesByKey![key.getDbTableKey()]!.getById(db, key)).then((entry) => entry as DB_ENTRY);

  Future<List<DB_ENTRY>> getWhere<DB_ENTRY extends DbEntry>(DbTableKey<DB_ENTRY> table, void Function(ConditionBuilder) conditions) {
    final ConditionBuilder builder = ConditionBuilder();
    conditions.call(builder);
    return _database.then((db) => _tablesByKey![table]!.getWhere(db, builder)).then((list) => list as List<DB_ENTRY>);
  }

  Future<void> closeDatabase() async {
    final Database db = await _database;
    await db.close();
  }

  Future<String> getExport() {
    return _database.then((db) => _DbExporter(db).getExport());
  }

  Future<void> setImport(String jsonString) {
    return _database.then((db) => _DbImporter(db).setImport(jsonString));
  }
}

class DbTableKey<DB_ENTRY extends DbEntry> {
  final String _key;

  DbTableKey(this._key);

  String getTableName() => _key;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DbTableKey && runtimeType == other.runtimeType && _key == other._key;

  @override
  int get hashCode => _key.hashCode;
}

abstract class DbEntryKey {
  final int intKey;

  DbEntryKey(this.intKey);

  DbTableKey getDbTableKey();

  @override
  bool operator ==(Object other) => identical(this, other) || other is DbEntryKey && runtimeType == other.runtimeType && intKey == other.intKey;

  @override
  int get hashCode => intKey.hashCode;
}

abstract class DbEntry {
  DbEntryKey getKey();

  Map<String, dynamic> toJson();
}

abstract class DbTable<DB_ENTRY extends DbEntry, DB_ENTRY_KEY extends DbEntryKey> {
  DbTableKey getDbTableKey();

  String getIdColumnName();

  Map<String, String> getDataColumnDefinitions();

  DB_ENTRY fromJson(Map<String, dynamic> entryJson);

  String createTableCommand() {
    String command = "CREATE TABLE " + getDbTableKey().getTableName() + " (" + getIdColumnName() + " INTEGER PRIMARY KEY";
    getDataColumnDefinitions().entries.forEach((columnDefinition) {
      command += ", " + columnDefinition.key + " " + columnDefinition.value;
    });
    command += ")";
    return command;
  }

  Future<int> insert(Database db, DB_ENTRY entry) async => await db.insert(getDbTableKey().getTableName(), entry.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);

  Future<int> update(Database db, DB_ENTRY entry) async =>
      await db.update(getDbTableKey().getTableName(), entry.toJson(), where: getIdColumnName() + " = ?", whereArgs: [entry.getKey().intKey]);

  Future<int> delete(Database db, DB_ENTRY_KEY key) async => await db.delete(getDbTableKey().getTableName(), where: getIdColumnName() + ' = ?', whereArgs: [key.intKey]);

  Future<List<DB_ENTRY>> getAll(Database db) async {
    final result = await db.query(getDbTableKey().getTableName(), columns: _getAllColumnNames());
    return result.toList(growable: false).map((entryJson) => fromJson(entryJson)).toList(growable: false);
  }

  Future<DB_ENTRY?> getById(Database db, DB_ENTRY_KEY key) async {
    final List<Map<String, dynamic>> results =
        await db.query(getDbTableKey().getTableName(), columns: _getAllColumnNames(), where: getIdColumnName() + ' = ?', whereArgs: [key.intKey]);
    if (results.length > 0) return fromJson(results.first);
    return null;
  }

  Future<List<DB_ENTRY>> getWhere(Database db, ConditionBuilder conditions) async {
    final result = await db.query(getDbTableKey().getTableName(), columns: _getAllColumnNames(), where: conditions.where, whereArgs: conditions.whereArgs);
    return result.toList(growable: false).map((entryJson) => fromJson(entryJson)).toList(growable: false);
  }

  List<String> _getAllColumnNames() {
    final List<String> allNames = List.empty(growable: true);
    allNames.add(getIdColumnName());
    allNames.addAll(getDataColumnDefinitions().keys);
    return allNames;
  }
}

class ConditionBuilder {
  String where = "";
  final List<dynamic> whereArgs = List.empty(growable: true);

  ConditionBuilder whereEquals(String columnName, dynamic value) {
    if (where.isNotEmpty) {
      where += " AND ";
    }
    where += columnName + " =?";
    whereArgs.add(value);
    return this;
  }

  ConditionBuilder whereNotEquals(String columnName, dynamic value) {
    if (where.isNotEmpty) {
      where += " AND NOT ";
    }
    where += columnName + " =?";
    whereArgs.add(value);
    return this;
  }
}

class _DbExporter {
  static const String HEAD_FORMAT_VERSION = "format version";
  static const String HEAD_CONTENT_VERSION = "content version";
  static const String TABLES = "tables";

  final Database db;

  _DbExporter(this.db);

  Future<String> getExport() async {
    final Map<String, dynamic> root = Map();
    root[HEAD_FORMAT_VERSION] = StarWarsDb._version.toString();
    root[HEAD_CONTENT_VERSION] = "0";
    final Map<String, dynamic> tables = Map();
    root[TABLES] = tables;
    await Future.wait(StarWarsDb._tables.map((table) => _getTableContent(table).then((content) => tables[table.getDbTableKey().getTableName()] = content)));
    return jsonEncode(root);
  }

  Future<List<Map<String, dynamic>>> _getTableContent(DbTable table) {
    return db.query(table.getDbTableKey().getTableName(), columns: table._getAllColumnNames());
  }
}

class _DbImporter {
  final Database db;

  _DbImporter(this.db);

  Future<void> setImport(String jsonString) async {
    final root = jsonDecode(jsonString);
    if (root[_DbExporter.HEAD_FORMAT_VERSION] != StarWarsDb._version.toString())
      throw Exception("Cannot update DB version yet (current: " + StarWarsDb._version.toString() + " read: " + root[_DbExporter.HEAD_FORMAT_VERSION]);
    // note: CONTENT_VERSION not yet checked

    final Map<String, dynamic> tables = root[_DbExporter.TABLES];
    final List<Future> futures = List.empty(growable: true);
    tables.forEach((tableName, entriesList) {
      futures.add(db.execute("DELETE FROM " + tableName).then((__) => Future.wait((entriesList as List).map((entry) => db.insert(tableName, entry)))));
    });
    return Future.wait(futures).then((value) => null);
  }
}
