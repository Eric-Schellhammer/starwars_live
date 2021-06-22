import 'package:moor/moor.dart';
import 'package:starwars_live/data_access/base_database.dart';
import 'package:starwars_live/model/person.dart';
import 'package:json_annotation/json_annotation.dart' as j;

/// This is a login account, associated to a Person

@j.JsonSerializable()
class AccountKey extends IntKey {
  AccountKey(int intKey) : super(intKey);
}

class Accounts extends Table {
  IntColumn get key => integer().map(AccountKeyConverter())();
  TextColumn get loginName => text()();
  TextColumn get password => text()();
  IntColumn get personKey => integer().map(PersonKeyConverter())();
}

class AccountKeyConverter extends IntKeyConverter<AccountKey> {
  @override
  AccountKey createKey(int fromDb) {
    return AccountKey(fromDb);
  }
}