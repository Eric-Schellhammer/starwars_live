import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

/// This is an in-game character, i.e. SC or NSC

const String _DB_ID = "id";
const String _DB_CODE = "code";
const String _DB_OWNER = "ownerKey";
const String _DB_TYPE = "type";
const String _DB_LEVEL = "level";

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
  int type;
  DocumentLevel level;

  Document({this.key, this.code, this.ownerKey, this.type, this.level});

  factory Document.fromJson(Map<String, dynamic> data) => new Document(
        key: DocumentKey(data[_DB_ID]),
        code: data[_DB_CODE],
        ownerKey: PersonKey(data[_DB_OWNER]),
        type: data[_DB_TYPE],
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
        _DB_TYPE: type,
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
