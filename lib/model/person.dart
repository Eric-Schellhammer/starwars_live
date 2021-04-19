import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/validation.dart';

/// This is an in-game character, i.e. SC or NSC

const String _DB_ID = "id";
const String _DB_FIRST_NAME = "first_name";
const String _DB_LAST_NAME = "last_name";
const String _DB_SCANNER_LEVEL = "scanner_level";
const String _DB_DOCUMENT_ID_KEY = "document_id";

class PersonKey extends DbEntryKey {
  static final DbTableKey<Person> dbTableKey = DbTableKey<Person>("Person");

  PersonKey(int intKey) : super(intKey);

  DbTableKey getDbTableKey() {
    return dbTableKey;
  }
}

class Person extends DbEntry {
  PersonKey key;
  String firstName;
  String lastName;
  ScannerLevel? scannerLevel;
  DocumentKey documentIdKey;

  Person({
    required this.key,
    required this.firstName,
    required this.lastName,
    this.scannerLevel,
    required this.documentIdKey,
  });

  factory Person.fromJson(Map<String, dynamic> data) => new Person(
        key: PersonKey(data[_DB_ID]),
        firstName: data[_DB_FIRST_NAME],
        lastName: data[_DB_LAST_NAME],
        scannerLevel: ScannerLevel(data[_DB_SCANNER_LEVEL]),
        documentIdKey: DocumentKey(data[_DB_DOCUMENT_ID_KEY]),
      );

  @override
  DbEntryKey getKey() {
    return key;
  }

  @override
  Map<String, dynamic> toJson() => {
        _DB_ID: key.intKey,
        _DB_FIRST_NAME: firstName,
        _DB_LAST_NAME: lastName,
        _DB_SCANNER_LEVEL: scannerLevel?.level ?? 0,
        _DB_DOCUMENT_ID_KEY: documentIdKey.intKey,
      };
}

class PersonTable extends DbTable<Person, PersonKey> {
  @override
  DbTableKey<Person> getDbTableKey() {
    return PersonKey.dbTableKey;
  }

  @override
  String getIdColumnName() {
    return _DB_ID;
  }

  @override
  Map<String, String> getDataColumnDefinitions() {
    return {
      _DB_FIRST_NAME: "TEXT",
      _DB_LAST_NAME: "TEXT",
      _DB_SCANNER_LEVEL: "INTEGER",
      _DB_DOCUMENT_ID_KEY: "INTEGER",
    };
  }

  @override
  Person fromJson(Map<String, dynamic> entryJson) => Person.fromJson(entryJson);
}
