import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';

const String LOGGED_IN_ACCOUNT = "logged-in-account";

abstract class DataService {
  late final StarWarsDb starWarsDb;

  DataService() {
    starWarsDb = StarWarsDb();
  }

  StarWarsDb getDb() {
    return starWarsDb;
  }

  /// returns the Account or null
  Future<Account?> validateAccount(String userName, String password);

  Future<ScanResult> resolveScannedCode(String data);
}

class DataServiceImpl extends DataService {
  @override
  Future<ScanResult> resolveScannedCode(String data) async {
    return getDb().getWhere(DocumentKey.dbTableKey, (conditions) => conditions.whereEquals(Document.COL_CODE, data)).then((documents) {
      if (documents.isEmpty)
        return ScanResult();
      else {
        final Document document = documents.first;
        return getDb().getById(document.ownerKey).then((person) => person as Person).then((person) {
          // TODO handle unknown person
          return RecognizedScanResult(
            personName: person.firstName + " " + person.lastName,
            personIsWanted: person.isWanted,
            document: document,
          );
        });
      }
    });
  }

  @override
  Future<Account?> validateAccount(String userName, String password) async {
    final matches =
        await getDb().getWhere(AccountKey.dbTableKey, (conditions) => conditions.whereEquals(Account.COL_LOGIN_NAME, userName).whereEquals(Account.COL_PASSWORD, password));
    return matches.isEmpty ? null : matches.first;
  }
}

class ScanResult {
  final bool idWasRecognized;

  ScanResult({this.idWasRecognized = false});
}

class RecognizedScanResult extends ScanResult {
  String? image;
  String personName;
  bool personIsWanted;
  Document document;

  RecognizedScanResult({
    this.image,
    required this.personName,
    required this.personIsWanted,
    required this.document,
  }) : super(idWasRecognized: true);
}
