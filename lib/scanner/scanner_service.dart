import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/validation.dart';

abstract class ScannerService {

  void setScanner(ScannerLevel? loggedInScannerLevel, bool hasMedScanner);

  bool isScannerPresent();

  bool hasMedScanner();

  bool isDocumentValid(Document document);
}

class ScannerServiceImpl extends ScannerService {
  ScannerLevel? loggedInScannerLevel;
  bool? medScanner;

  @override
  void setScanner(ScannerLevel? loggedInScannerLevel, bool medScanner) {
    this.loggedInScannerLevel = loggedInScannerLevel;
    this.medScanner = medScanner;
  }

  @override
  bool isScannerPresent() {
    return loggedInScannerLevel != null && loggedInScannerLevel!.level != 0;
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