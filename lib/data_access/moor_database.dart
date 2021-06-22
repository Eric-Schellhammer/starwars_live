import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/banking.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

part 'moor_database.g.dart';

@UseMoor(tables: [Persons, Accounts, CreditTransfers, Documents])
class StarWarsDb extends _$StarWarsDb {
  StarWarsDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'star_wars_db.sqlite'));
    return VmDatabase(file);
  });
}
