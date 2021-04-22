import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

/// This is an in-game character, i.e. SC or NSC

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

  static final PERSONAL_ID = DocumentType._(1, "Persönliche ID");
  static final CAPTAINS_LICENCE = DocumentType._(2, "Kapitänslizenz");
  static final VEHICLE_REGISTRATION = DocumentType._(3, "Schiffsregistrierung");
  static final WEAPON_LICENCE = DocumentType._(4, "Waffenlizenz");
  static final SECTOR_TRADE_LICENCE = DocumentType._(5, "Sektor-Handelslizenz");
  static final UNKNOWN = DocumentType._(0, "unbekanntes Dokument");
}

class DocumentKey extends DbEntryKey {
  static final DbTableKey<Document> dbTableKey = DbTableKey<Document>("Document");

  DocumentKey(int intKey) : super(intKey);

  DbTableKey getDbTableKey() {
    return dbTableKey;
  }
}

class Document extends DbEntry {
  static const String COL_ID = "id";
  static const String COL_CODE = "code";
  static const String COL_OWNER = "ownerKey";
  static const String COL_TYPE = "type";
  static const String COL_LEVEL = "level";

  DocumentKey key;
  String code;
  PersonKey ownerKey;
  DocumentType type;
  DocumentLevel level;

  Document({
    required this.key,
    required this.code,
    required this.ownerKey,
    required this.type,
    required this.level,
  });

  factory Document.fromJson(Map<String, dynamic> data) => new Document(
        key: DocumentKey(data[COL_ID]),
        code: data[COL_CODE],
        ownerKey: PersonKey(data[COL_OWNER]),
        type: DocumentType.fromKey(data[COL_TYPE]),
        level: DocumentLevel.createForgery(data[COL_LEVEL]),
      );

  @override
  DbEntryKey getKey() {
    return key;
  }

  @override
  Map<String, dynamic> toJson() => {
        COL_ID: key.intKey,
        COL_CODE: code,
        COL_OWNER: ownerKey.intKey,
        COL_TYPE: type.intKey,
        COL_LEVEL: level.level,
      };
}

class DocumentTable extends DbTable<Document, DocumentKey> {
  @override
  DbTableKey<Document> getDbTableKey() {
    return DocumentKey.dbTableKey;
  }

  @override
  String getIdColumnName() {
    return Document.COL_ID;
  }

  @override
  Map<String, String> getDataColumnDefinitions() {
    return {
      Document.COL_CODE: "TEXT",
      Document.COL_OWNER: "INTEGER",
      Document.COL_TYPE: "INTEGER",
      Document.COL_LEVEL: "INTEGER",
    };
  }

  @override
  Document fromJson(Map<String, dynamic> entryJson) => Document.fromJson(entryJson);
}
