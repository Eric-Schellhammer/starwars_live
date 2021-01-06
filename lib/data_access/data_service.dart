import 'package:starwars_live/data_access/local_database.dart';

enum DocumentType {
  PERSONAL_ID,
  CAPTAINS_LICENCE,
  VEHICLE_REGISTRATION,
  WEAPON_LICENCE,
  SECTOR_TRADE_LICENCE
}

abstract class DataService {
  StarWarsDb starWarsDb;

  DataService() {
    starWarsDb = StarWarsDb();
  }

  StarWarsDb getDb() {
    return starWarsDb;
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
    // TODO: implement validateAccount
    return Future.value(userName.length > 1);
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
