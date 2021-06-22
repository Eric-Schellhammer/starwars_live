import 'package:json_annotation/json_annotation.dart' as j;
import 'package:starwars_live/data_access/base_database.dart';

@j.JsonSerializable()
class DocumentLevel extends IntKey {
  factory DocumentLevel.createValid() => DocumentLevel._(0);

  factory DocumentLevel.createForgery(int level) => DocumentLevel._(level);

  DocumentLevel._(int level) : super(level);

  bool isValid() {
    return intKey == 0;
  }

  /// only returns a valid value if isValid() is false
  int levelOfForgery() {
    return intKey;
  }
}

@j.JsonSerializable()
class ScannerLevel extends IntKey {
  ScannerLevel(int level) : super(level);

  bool isValid(DocumentLevel documentLevel) {
    return documentLevel.isValid() || this.intKey < documentLevel.levelOfForgery();
  }
}

class ScannerLevelConverter extends IntKeyConverter<ScannerLevel> {
  @override
  ScannerLevel createKey(int fromDb) => ScannerLevel(fromDb);
}