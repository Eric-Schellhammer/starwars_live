import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

const String LOGGED_IN_ACCOUNT = "logged-in-account";

abstract class DataService {
  late final StarWarsDb starWarsDb;

  DataService() {
    starWarsDb = StarWarsDb();
    _loadDefaultDb(starWarsDb);
  }

  StarWarsDb getDb() {
    return starWarsDb;
  }

  void _loadDefaultDb(StarWarsDb db) {
    final PersonKey MARTY = PersonKey(1);
    db.insert(Account(key: AccountKey(1), loginName: "abc", password: "123", personKey: MARTY));
    db.insert(Person(key: MARTY, firstName: "Marty", lastName: "McFly", documentIdKey: DocumentKey(1), scannerLevel: ScannerLevel(7)));
    db.insert(Document(key: DocumentKey(1), code: "UZGOJ", ownerKey: MARTY, type: DocumentType.PERSONAL_ID, information: "Marty McFly", level: DocumentLevel.createValid()));
    db.insert(
        Document(key: DocumentKey(3), code: "USJBE", ownerKey: MARTY, type: DocumentType.VEHICLE_REGISTRATION, information: "Rocinante", level: DocumentLevel.createForgery(3)));
    db.insert(
        Document(key: DocumentKey(5), code: "XXEREYBE", ownerKey: MARTY, type: DocumentType.SECTOR_TRADE_LICENCE, level: DocumentLevel.createForgery(5)));
    db.insert(Document(key: DocumentKey(4), code: "FFDES", ownerKey: MARTY, type: DocumentType.CAPTAINS_LICENCE, level: DocumentLevel.createForgery(3)));
    final PersonKey BIFF = PersonKey(2);
    db.insert(Account(key: AccountKey(2), loginName: "abcd", password: "1234", personKey: BIFF));
    db.insert(Person(key: BIFF, firstName: "Biff", lastName: "Tannen", documentIdKey: DocumentKey(2)));
    db.insert(Document(key: DocumentKey(2), code: "UZGOJX", ownerKey: BIFF, type: DocumentType.PERSONAL_ID, information: "Biff Tannen", level: DocumentLevel.createForgery(3)));
  }

  bool isAvailable(String serverIpAddress);

  /// returns the AccountKey or null
  Future<AccountKey?> validateAccount(String userName, String password);

  ScanResult scan(String data);
}

class DataServiceImpl extends DataService {
  @override
  bool isAvailable(String serverIpAddress) {
    // TODO: implement isAvailable
    return false;
  }

  @override
  ScanResult scan(String data) {
    // TODO: implement scan
    return ScanResult();
  }

  @override
  Future<AccountKey?> validateAccount(String userName, String password) async {
    final matches =
        await getDb().getWhere(AccountKey.dbTableKey, (conditions) => conditions.whereEquals(Account.COL_LOGIN_NAME, userName).whereEquals(Account.COL_PASSWORD, password));
    return matches.isEmpty ? null : matches.first.key;
  }
}

class ScanResult {
  final bool idWasRecognized;

  ScanResult({this.idWasRecognized = false});
}

class RecognizedScanResult extends ScanResult {
  String? image;
  String personName;
  DocumentType documentType;
  String additionalInformation;
  bool idIsValid;
  bool personIsOk;

  RecognizedScanResult({
    this.image,
    required this.personName,
    required this.documentType,
    required this.additionalInformation,
    required this.idIsValid,
    required this.personIsOk,
  }) : super(idWasRecognized: true);
}
