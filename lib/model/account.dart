import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/person.dart';

/// This is a login account, associated to a Person

const String _DB_ID = "id";
const String _DB_LOGIN_NAME = "login_name";
const String _DB_PASSWORD = "password";
const String _DB_PERSON = "person";

class AccountKey extends DbEntryKey {
  static final DbTableKey<Account> dbTableKey = DbTableKey<Account>("Account");

  AccountKey(int intKey) : super(intKey);

  DbTableKey getDbTableKey() {
    return dbTableKey;
  }
}

class Account extends DbEntry {
  AccountKey key;
  String loginName;
  String password;
  PersonKey personKey;

  Account({
    required this.key,
    required this.loginName,
    required this.password,
    required this.personKey,
  });

  factory Account.fromJson(Map<String, dynamic> data) => new Account(
        key: AccountKey(data[_DB_ID]),
        loginName: data[_DB_LOGIN_NAME],
        password: data[_DB_PASSWORD],
        personKey: PersonKey(data[_DB_PERSON]),
      );

  @override
  DbEntryKey getKey() {
    return key;
  }

  @override
  Map<String, dynamic> toJson() => {
        _DB_ID: key.intKey,
        _DB_LOGIN_NAME: loginName,
        _DB_PASSWORD: password,
        _DB_PERSON: personKey.intKey,
      };
}

class AccountTable extends DbTable<Account, AccountKey> {
  @override
  DbTableKey<Account> getDbTableKey() {
    return AccountKey.dbTableKey;
  }

  @override
  String getIdColumnName() {
    return _DB_ID;
  }

  @override
  Map<String, String> getDataColumnDefinitions() {
    return {
      _DB_LOGIN_NAME: "TEXT",
      _DB_PASSWORD: "TEXT",
      _DB_PERSON: "INTEGER",
    };
  }

  @override
  Account fromJson(Map<String, dynamic> entryJson) => Account.fromJson(entryJson);
}
