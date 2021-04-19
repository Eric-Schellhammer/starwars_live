import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

const String LOGGED_IN_ACCOUNT = "logged-in-account";

abstract class DataService {
  StarWarsDb starWarsDb;

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
    db.insert(Document(key: DocumentKey(1), code: "UZGOJ", ownerKey: MARTY, type: DocumentType.PERSONAL_ID, level: DocumentLevel.createValid()));
    final PersonKey BIFF = PersonKey(2);
    db.insert(Account(key: AccountKey(2), loginName: "abcd", password: "1234", personKey: BIFF));
    db.insert(Person(key: BIFF, firstName: "Biff", lastName: "Tannen", documentIdKey: DocumentKey(2)));
    db.insert(Document(key: DocumentKey(2), code: "UZGOJX", ownerKey: BIFF, type: DocumentType.PERSONAL_ID, level: DocumentLevel.createForgery(3)));
  }

  bool isAvailable(String serverIpAddress);

  /// returns the AccountKey or null
  Future<AccountKey> validateAccount(String userName, String password);

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
    final ScanResult result = ScanResult();
    if (data == "4711") {
      result.idWasRecognized = true;
      result.personName = "Varian Caltrel";
      result.documentType = DocumentType.PERSONAL_ID;
      result.idIsValid = true;
      result.personIsOk = true;
    }
    if (data == "4711-1") {
      result.idWasRecognized = true;
      result.personName = "Varian Caltrel";
      result.documentType = DocumentType.CAPTAINS_LICENCE;
      result.idIsValid = false;
      result.personIsOk = true;
    }
    if (data == "4711-2") {
      result.idWasRecognized = true;
      result.personName = "Varian Caltrel";
      result.documentType = DocumentType.PERSONAL_ID;
      result.idIsValid = true;
      result.personIsOk = false;
    }
    if (data == "4711-3") {
      result.idWasRecognized = true;
      result.personName = "Varian Caltrel";
      result.documentType = DocumentType.VEHICLE_REGISTRATION;
      result.additionalInformation = "\"Rocinante\"";
      result.idIsValid = true;
      result.personIsOk = true;
    }
    return result;
  }

  @override
  Future<AccountKey> validateAccount(String userName, String password) {
    return getDb().getAll(AccountKey.dbTableKey).then((accounts) {
      final matches = accounts.where((account) => account.loginName == userName).where((account) => account.password == password);
      return matches.isEmpty ? null : matches.first.key;
    });
  }
}

class ScanResult {
  bool idWasRecognized = false;
  String image;
  String personName;
  DocumentType documentType;
  String additionalInformation;
  bool idIsValid;
  bool personIsOk;
}
