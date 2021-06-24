import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:moor/moor.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/banking.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/ui_services/user_service.dart';

import 'moor_database.dart';

class DataServiceImpl extends DataService {
  late final StarWarsDb db;

  DataServiceImpl() {
    db = StarWarsDb();
  }

  StarWarsDb getDb() {
    return db;
  }

  @override
  Future<Account?> validateAccount(String userName, String password) async {
    final matches = await (db.select(db.accounts)..where((account) => account.loginName.equals(userName) & account.password.equals(password))).get();
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<Account?> getAccountByKey(AccountKey accountKey) {
    return (db.select(db.accounts)..where((account) => account.key.equals(accountKey.intKey))).getSingleOrNull();
  }

  @override
  Future<Person?> getPersonByKey(PersonKey personKey) {
    return (db.select(db.persons)..where((tbl) => tbl.id.equals(personKey.intKey))).getSingleOrNull();
  }

  @override
  Future<int> getCredits(PersonKey personKey) {
    return GetIt.instance.get<UserService>().getLoggedInPerson().then((person) => person.bankAccountKey).then((loggedInBankAccount) async {
      int amount = 0;
      await (db.select(db.creditTransfers)..where((transfer) => transfer.receiver.equals(loggedInBankAccount.intKey)))
          .get()
          .then((receivingTransfers) => receivingTransfers.forEach((transfer) => amount += transfer.amount));
      await (db.select(db.creditTransfers)..where((transfer) => transfer.sender.equals(loggedInBankAccount.intKey)))
          .get()
          .then((sendingTransfers) => sendingTransfers.forEach((transfer) => amount -= transfer.amount));
      return amount;
    });
  }

  @override
  Future<Document?> getDocumentForCode(String code) {
    return (db.select(db.documents)..where((document) => document.code.equals(code))).getSingleOrNull();
  }

  @override
  Future<List<Document>> getDocumentsOfPerson(PersonKey personKey) {
    return (db.select(db.documents)
          ..where((document) => document.ownerKey.equals(personKey.intKey)))
        .get();
  }

  @override
  Future<Document?> getDocumentByKey(DocumentKey documentKey) {
    return (db.select(db.documents)..where((document) => document.id.equals(documentKey.intKey))).getSingleOrNull();
  }

  @override
  Future<Person?> getPersonForBankAccount(String accountKeyAsString) {
    try {
      final key = BankAccountKey(int.parse(accountKeyAsString));
      return (db.select(db.persons)..where((person) => person.bankAccountKey.equals(key.intKey))).getSingleOrNull();
    } catch (e) {
      return Future.value(null);
    }
  }

  @override
  Future<CreditTransfer?> getTransferForCode(String code) {
    return (db.select(db.creditTransfers)..where((transfer) => transfer.code.equals(code))).getSingleOrNull();
  }

  @override
  Future<void> addTransfer(CreditTransfer creditTransfer) {
    return db.into(db.creditTransfers).insert(creditTransfer);
  }

  @override
  Future<String> getExport() => _DbExporter(getDb()).getExport();

  @override
  Future<void> setImport(String jsonString) => _DbImporter(getDb()).setImport(jsonString);
}

class _DbExporter {
  static const String HEAD_FORMAT_VERSION = "format version";
  static const String HEAD_CONTENT_VERSION = "content version";
  static const String TABLES = "tables";

  final StarWarsDb db;

  _DbExporter(this.db);

  Future<String> getExport() async {
    final Map<String, dynamic> root = Map();
    // root[HEAD_FORMAT_VERSION] = StarWarsDb.version.toString();
    // root[HEAD_CONTENT_VERSION] = "0";
    final Map<String, dynamic> tables = Map();
    root[TABLES] = tables;
    await Future.wait(db.allTables.map((table) => _getTableContent(table).then((content) => tables[table.actualTableName] = content)));
    return jsonEncode(root);
  }

  Future<List<Map<String, dynamic>>> _getTableContent(TableInfo table) {
    return db.select(table).get().then((entities) => entities.map((e) => (e as Insertable).toColumns(true).map((key, value) => MapEntry(key, (value as Variable).value))).toList());
  }
}

class _DbImporter {
  final StarWarsDb db;

  _DbImporter(this.db);

  Future<void> setImport(String jsonString) async {
    final root = jsonDecode(jsonString);
    //if (root[_DbExporter.HEAD_FORMAT_VERSION] != StarWarsDb._version.toString())
    //  throw Exception("Cannot update DB version yet (current: " + StarWarsDb._version.toString() + " read: " + root[_DbExporter.HEAD_FORMAT_VERSION]);
    // note: CONTENT_VERSION not yet checked

    final List<Future> futures = List.empty(growable: true);
    final Map<String, dynamic> importedTables = root[_DbExporter.TABLES];
    db.allTables.forEach((tableInfo) => futures.add(db.delete(tableInfo).go().then((__) {
          final List<Future> insertFutures = List.empty(growable: true);
          importedTables[tableInfo.actualTableName].forEach((entity) => insertFutures.add(insert(tableInfo, entity)));
          return Future.wait(insertFutures);
        })));
    return Future.wait(futures).then((value) => null);
  }

  Future<int> insert(TableInfo table, Map<String, dynamic> entity) async {
    return db.into(table).insert(table.map(entity));
  }
}
