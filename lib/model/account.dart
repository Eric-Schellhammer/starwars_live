import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/person.dart';

/// This is a login account, associated to a Person

class AccountKey extends DbEntryKey {
  static final DbTableKey<Account> dbTableKey = DbTableKey<Account>("Account");

  AccountKey(int intKey) : super(intKey);

  DbTableKey getDbTableKey() {
    return dbTableKey;
  }
}

class Account extends DbEntry {
  static const String COL_ID = "id";
  static const String COL_LOGIN_NAME = "login_name";
  static const String COL_PASSWORD = "password";
  static const String COL_PERSON = "person";

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
        key: AccountKey(data[COL_ID]),
        loginName: data[COL_LOGIN_NAME],
        password: data[COL_PASSWORD],
        personKey: PersonKey(data[COL_PERSON]),
      );

  @override
  DbEntryKey getKey() {
    return key;
  }

  @override
  Map<String, dynamic> toJson() => {
        COL_ID: key.intKey,
        COL_LOGIN_NAME: loginName,
        COL_PASSWORD: password,
        COL_PERSON: personKey.intKey,
      };
}

class AccountTable extends DbTable<Account, AccountKey> {
  @override
  DbTableKey<Account> getDbTableKey() {
    return AccountKey.dbTableKey;
  }

  @override
  String getIdColumnName() {
    return Account.COL_ID;
  }

  @override
  Map<String, String> getDataColumnDefinitions() {
    return {
      Account.COL_LOGIN_NAME: "TEXT",
      Account.COL_PASSWORD: "TEXT",
      Account.COL_PERSON: "INTEGER",
    };
  }

  @override
  Account fromJson(Map<String, dynamic> entryJson) => Account.fromJson(entryJson);
}
