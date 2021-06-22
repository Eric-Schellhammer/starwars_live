import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/moor_database.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

abstract class UserService {
  void setUser(PersonKey personKey, ScannerLevel? loggedInScannerLevel, bool hasMedScanner);

  PersonKey getLoggedInPersonKey();

  Future<Person> getLoggedInPerson();

  bool isScannerPresent();

  bool hasMedScanner();

  /// return whether the user thinks this document is valid
  bool isDocumentValid(Document document);
}

class UserServiceImpl extends UserService {
  PersonKey? personKey;
  ScannerLevel? loggedInScannerLevel;
  bool? medScanner;

  @override
  void setUser(PersonKey personKey, ScannerLevel? loggedInScannerLevel, bool medScanner) {
    this.personKey = personKey;
    this.loggedInScannerLevel = loggedInScannerLevel;
    this.medScanner = medScanner;
  }

  @override
  PersonKey getLoggedInPersonKey() {
    return personKey!;
  }

  @override
  Future<Person> getLoggedInPerson() {
    return GetIt.instance.get<DataService>().getPersonByKey(personKey!).then((person) => person!);
  }

  @override
  bool isScannerPresent() {
    return loggedInScannerLevel != null && loggedInScannerLevel!.intKey != 0;
  }

  @override
  bool hasMedScanner() {
    return medScanner == true;
  }

  @override
  bool isDocumentValid(Document document) {
    return loggedInScannerLevel?.isValid(document.level) ?? true;
  }
}
