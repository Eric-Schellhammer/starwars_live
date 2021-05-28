import 'package:starwars_live/data_access/local_database.dart';
import 'package:intl/intl.dart';

const String TRANSFER_JSON_CODE = "transferCode";
const String TRANSFER_JSON_RECEIVER = "receiver";
const String TRANSFER_JSON_SENDER = "sender";
const String TRANSFER_JSON_AMOUNT = "amount";

class BankAccountKey {
  final int intKey;

  BankAccountKey(this.intKey);

  @override
  bool operator ==(Object other) => identical(this, other) || other is BankAccountKey && runtimeType == other.runtimeType && intKey == other.intKey;

  @override
  int get hashCode => intKey.hashCode;
}

class BankBalance {
  final int amount;

  BankBalance(this.amount);

  @override
  String toString() {
    return NumberFormat("#,###", "de_DE").format(amount) + " Credits";
  }
}

/// This is a transfer of credits between to persons

class CreditTransferKey extends DbEntryKey {
  static final DbTableKey<CreditTransfer> dbTableKey = DbTableKey<CreditTransfer>("CreditTransfer");

  CreditTransferKey(int intKey) : super(intKey);

  DbTableKey getDbTableKey() {
    return dbTableKey;
  }
}

class CreditTransfer extends DbEntry {
  static const String COL_TRANSFER_CODE = "code";
  static const String COL_SENDER_ID = "sender";
  static const String COL_RECEIVER_ID = "receiver";
  static const String COL_AMOUNT = "amount";

  String code;
  BankAccountKey sender;
  BankAccountKey receiver;
  int amount;

  CreditTransfer({
    required this.code,
    required this.sender,
    required this.receiver,
    required this.amount,
  });

  factory CreditTransfer.fromJson(Map<String, dynamic> data) => new CreditTransfer(
        code: data[COL_TRANSFER_CODE],
        sender: BankAccountKey(data[COL_SENDER_ID]),
        receiver: BankAccountKey(data[COL_RECEIVER_ID]),
        amount: data[COL_AMOUNT] ?? 0,
      );

  @override
  DbEntryKey getKey() {
    return CreditTransferKey(-1);
  }

  @override
  Map<String, dynamic> toJson() => {
        COL_TRANSFER_CODE: code,
        COL_SENDER_ID: sender.intKey,
        COL_RECEIVER_ID: receiver.intKey,
        COL_AMOUNT: amount,
      };
}

class CreditTransferTable extends DbTable<CreditTransfer, CreditTransferKey> {
  @override
  DbTableKey<CreditTransfer> getDbTableKey() {
    return CreditTransferKey.dbTableKey;
  }

  @override
  String? getIdColumnName() {
    return null;
  }

  @override
  Map<String, String> getDataColumnDefinitions() {
    return {
      CreditTransfer.COL_TRANSFER_CODE: "TEXT",
      CreditTransfer.COL_SENDER_ID: "INTEGER",
      CreditTransfer.COL_RECEIVER_ID: "INTEGER",
      CreditTransfer.COL_AMOUNT: "INTEGER",
    };
  }

  @override
  CreditTransfer fromJson(Map<String, dynamic> entryJson) => CreditTransfer.fromJson(entryJson);
}
