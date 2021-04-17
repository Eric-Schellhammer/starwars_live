import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/person.dart';

enum DocumentType { PERSONAL_ID, CAPTAINS_LICENCE, VEHICLE_REGISTRATION, WEAPON_LICENCE, SECTOR_TRADE_LICENCE }

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
    db.insert(Account(key: AccountKey(1), loginName: "abc", password: "123", personKey: PersonKey(1)));
    db.insert(Person(key: PersonKey(1), firstName: "Marty", lastName: "McFly"));
  }


  bool isAvailable(String serverIpAddress);

  Future<bool> validateAccount(String userName, String password);

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
  Future<bool> validateAccount(String userName, String password) {
    return getDb().getAll(AccountKey.dbTableKey).then((accounts) => accounts.where((element) => element.loginName == userName).any((element) => element.password == password));
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
