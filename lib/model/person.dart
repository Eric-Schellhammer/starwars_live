import 'package:sqflite/sqflite.dart';
import 'package:starwars_live/data_access/local_database.dart';

/// This is an in-game character, i.e. SC or NSC

const String _DB_ID = "id";
const String _DB_FIRST_NAME = "first_name";
const String _DB_LAST_NAME = "last_name";

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

  Person({this.key, this.firstName, this.lastName});

  factory Person.fromJson(Map<String, dynamic> data) => new Person(
        key: PersonKey(data[_DB_ID]),
        firstName: data[_DB_FIRST_NAME],
        lastName: data[_DB_LAST_NAME],
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
    };
  }

  @override
  Person fromJson(Map<String, dynamic> entryJson) => Person.fromJson(entryJson);
}
