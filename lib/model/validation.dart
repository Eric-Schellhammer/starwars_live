
class DocumentLevel {
  final int level;

  factory DocumentLevel.createValid() => DocumentLevel._(0);

  factory DocumentLevel.createForgery(int level) => DocumentLevel._(level);

  DocumentLevel._(this.level);

  bool isValid() {
    return level == 0;
  }

  /// only returns a valid value if isValid() is false
  int levelOfForgery() {
    return level;
  }
}

class ScannerLevel {
  final int level;

  ScannerLevel(this.level);

  bool isValid(DocumentLevel documentLevel) {
    return documentLevel.isValid() || this.level < documentLevel.levelOfForgery();
  }
}