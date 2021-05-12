import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/validation.dart';

/// This is an in-game character, i.e. SC or NSC

class PersonKey extends DbEntryKey {
  static final DbTableKey<Person> dbTableKey = DbTableKey<Person>("Person");

  PersonKey(int intKey) : super(intKey);

  DbTableKey getDbTableKey() {
    return dbTableKey;
  }
}

class Person extends DbEntry {
  static const String COL_ID = "id";
  static const String COL_FIRST_NAME = "first_name";
  static const String COL_LAST_NAME = "last_name";
  static const String COL_SCANNER_LEVEL = "scanner_level";
  static const String COL_DOCUMENT_ID_KEY = "document_id";
  static const String COL_CREDITS = "credits";
  static const String COL_WANTED = "wanted";

  PersonKey key;
  String firstName;
  String lastName;
  ScannerLevel? scannerLevel;
  DocumentKey documentIdKey;
  int credits;
  bool isWanted;

  Person({
    required this.key,
    required this.firstName,
    required this.lastName,
    this.scannerLevel,
    required this.documentIdKey,
    this.credits = 0,
    this.isWanted = false,
  });

  factory Person.fromJson(Map<String, dynamic> data) => new Person(
        key: PersonKey(data[COL_ID]),
        firstName: data[COL_FIRST_NAME],
        lastName: data[COL_LAST_NAME],
        scannerLevel: ScannerLevel(data[COL_SCANNER_LEVEL]),
        documentIdKey: DocumentKey(data[COL_DOCUMENT_ID_KEY]),
        credits: data[COL_CREDITS] ?? 0,
        isWanted: data[COL_WANTED] != 0,
      );

  @override
  DbEntryKey getKey() {
    return key;
  }

  @override
  Map<String, dynamic> toJson() => {
        COL_ID: key.intKey,
        COL_FIRST_NAME: firstName,
        COL_LAST_NAME: lastName,
        COL_SCANNER_LEVEL: scannerLevel?.level ?? 0,
        COL_DOCUMENT_ID_KEY: documentIdKey.intKey,
        COL_CREDITS: credits,
        COL_WANTED: isWanted ? 1 : 0,
      };
}

class PersonTable extends DbTable<Person, PersonKey> {
  @override
  DbTableKey<Person> getDbTableKey() {
    return PersonKey.dbTableKey;
  }

  @override
  String getIdColumnName() {
    return Person.COL_ID;
  }

  @override
  Map<String, String> getDataColumnDefinitions() {
    return {
      Person.COL_FIRST_NAME: "TEXT",
      Person.COL_LAST_NAME: "TEXT",
      Person.COL_SCANNER_LEVEL: "INTEGER",
      Person.COL_DOCUMENT_ID_KEY: "INTEGER",
      Person.COL_CREDITS: "INTEGER",
      Person.COL_WANTED: "INTEGER",
    };
  }

  @override
  Person fromJson(Map<String, dynamic> entryJson) => Person.fromJson(entryJson);
}
