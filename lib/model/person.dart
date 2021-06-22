import 'package:json_annotation/json_annotation.dart' as j;
import 'package:moor/moor.dart';
import 'package:starwars_live/data_access/base_database.dart';
import 'package:starwars_live/model/validation.dart';

import 'banking.dart';
import 'document.dart';

@j.JsonSerializable()
class PersonKey extends IntKey {
  PersonKey(int intKey) : super(intKey);
}

class Persons extends Table {
  IntColumn get id => integer().map(PersonKeyConverter())();

  TextColumn get firstName => text()();

  TextColumn get lastName => text()();

  IntColumn get scannerLevel => integer().map(ScannerLevelConverter()).nullable()();

  IntColumn get documentIdKey => integer().map(DocumentKeyConverter())();

  IntColumn get bankAccountKey => integer().map(BankAccountKeyConverter())();

  BoolColumn get hasMedScanner => boolean().withDefault(const Constant(false))();

  BoolColumn get isWanted => boolean().withDefault(const Constant(false))();
}

class PersonKeyConverter extends IntKeyConverter<PersonKey> {
  @override
  PersonKey createKey(int fromDb) => PersonKey(fromDb);
}
