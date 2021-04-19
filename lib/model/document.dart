import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

/// This is an in-game character, i.e. SC or NSC

const String _DB_ID = "id";
const String _DB_CODE = "code";
const String _DB_OWNER = "ownerKey";
const String _DB_TYPE = "type";
const String _DB_LEVEL = "level";

class DocumentType {
  static final Map<int, DocumentType> _typeByKey = Map();
  final int _key;
  final String name;

  DocumentType._(this._key, this.name) {
    _typeByKey.putIfAbsent(_key, () => this);
  }

  static DocumentType fromKey(int key) {
    return _typeByKey[key] ?? UNKNOWN;
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is DocumentType && runtimeType == other.runtimeType && _key == other._key;

  @override
  int get hashCode => _key.hashCode;

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
        key: DocumentKey(data[_DB_ID]),
        code: data[_DB_CODE],
        ownerKey: PersonKey(data[_DB_OWNER]),
        type: DocumentType.fromKey(data[_DB_TYPE]),
        level: DocumentLevel.createForgery(data[_DB_LEVEL]),
      );

  @override
  DbEntryKey getKey() {
    return key;
  }

  @override
  Map<String, dynamic> toJson() => {
        _DB_ID: key.intKey,
        _DB_CODE: code,
        _DB_OWNER: ownerKey.intKey,
        _DB_TYPE: type._key,
        _DB_LEVEL: level.level,
      };
}

class DocumentTable extends DbTable<Document, DocumentKey> {
  @override
  DbTableKey<Document> getDbTableKey() {
    return DocumentKey.dbTableKey;
  }

  @override
  String getIdColumnName() {
    return _DB_ID;
  }

  @override
  Map<String, String> getDataColumnDefinitions() {
    return {
      _DB_CODE: "TEXT",
      _DB_OWNER: "INTEGER",
      _DB_TYPE: "INTEGER",
      _DB_LEVEL: "INTEGER",
    };
  }

  @override
  Document fromJson(Map<String, dynamic> entryJson) => Document.fromJson(entryJson);
}
