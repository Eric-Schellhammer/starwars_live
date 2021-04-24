import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/validation.dart';

abstract class ScannerService {

  void setScanner(ScannerLevel? loggedInScannerLevel);

  bool isScannerPresent();

  bool isDocumentValid(Document document);
}

class ScannerServiceImpl extends ScannerService {
  ScannerLevel? loggedInScannerLevel;

  @override
  void setScanner(ScannerLevel? loggedInScannerLevel) {
    this.loggedInScannerLevel = loggedInScannerLevel;
  }

  @override
  bool isScannerPresent() {
    return loggedInScannerLevel != null && loggedInScannerLevel!.level != 0;
  }

  @override
  bool isDocumentValid(Document document) {
    return loggedInScannerLevel?.isValid(document.level) ?? true;
  }
}