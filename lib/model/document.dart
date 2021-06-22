import 'package:json_annotation/json_annotation.dart' as j;
import 'package:moor/moor.dart';
import 'package:starwars_live/data_access/base_database.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

/// this is a Document owned by a Person

@j.JsonSerializable()
class DocumentType {
  static final Map<int, DocumentType> _typeByKey = Map();
  final int intKey;
  final String name;

  DocumentType._(this.intKey, this.name) {
    _typeByKey.putIfAbsent(intKey, () => this);
  }

  static DocumentType fromKey(int key) {
    return _typeByKey[key] ?? UNKNOWN;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DocumentType && runtimeType == other.runtimeType && intKey == other.intKey;

  @override
  int get hashCode => intKey.hashCode;

  int toJson() {
    return intKey;
  }

  static final PERSONAL_ID = DocumentType._(1, "Persönliche ID");
  static final CAPTAINS_LICENCE = DocumentType._(2, "Kapitänslizenz");
  static final VEHICLE_REGISTRATION = DocumentType._(3, "Schiffsregistrierung");
  static final WEAPON_LICENCE = DocumentType._(4, "Waffenlizenz");
  static final SECTOR_TRADE_LICENCE = DocumentType._(5, "Sektor-Handelslizenz");
  static final UNKNOWN = DocumentType._(0, "unbekanntes Dokument");

  static List<DocumentType> ensureLoaded() {
    return [
      PERSONAL_ID,
      CAPTAINS_LICENCE,
      VEHICLE_REGISTRATION,
      WEAPON_LICENCE,
      SECTOR_TRADE_LICENCE,
      UNKNOWN,
    ];
  }
}

@j.JsonSerializable()
class DocumentKey extends IntKey {
  DocumentKey(int intKey) : super(intKey);
}

class Documents extends Table {
  IntColumn get id => integer().map(DocumentKeyConverter())();

  TextColumn get code => text()();

  IntColumn get ownerKey => integer().map(PersonKeyConverter())();

  IntColumn get documentType => integer().map(DocumentTypeConverter())();

  TextColumn get information => text().nullable()();

  IntColumn get level => integer().map(DocumentLevelConverter())();
}

class DocumentKeyConverter extends IntKeyConverter<DocumentKey> {
  @override
  DocumentKey createKey(int fromDb) => DocumentKey(fromDb);
}

class DocumentTypeConverter extends TypeConverter<DocumentType, int> {
  @override
  DocumentType? mapToDart(int? fromDb) {
    return fromDb != null ? DocumentType.fromKey(fromDb) : null;
  }

  @override
  int? mapToSql(DocumentType? value) {
    return value != null ? value.intKey : null;
  }
}

class DocumentLevelConverter extends IntKeyConverter<DocumentLevel> {
  @override
  DocumentLevel createKey(int fromDb) {
    return DocumentLevel.createForgery(fromDb);
  }
}
