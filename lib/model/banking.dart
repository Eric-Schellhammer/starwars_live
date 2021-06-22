import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart' as j;
import 'package:moor/moor.dart';
import 'package:starwars_live/data_access/base_database.dart';

const String TRANSFER_JSON_CODE = "code";
const String TRANSFER_JSON_RECEIVER = "receiver";
const String TRANSFER_JSON_SENDER = "sender";
const String TRANSFER_JSON_AMOUNT = "amount";

@j.JsonSerializable()
class BankAccountKey extends IntKey {
  BankAccountKey(int intKey) : super(intKey);
}

@j.JsonSerializable()
class BankBalance extends IntKey {
  BankBalance(int amount) :super(amount);

  @override
  String toString() {
    return NumberFormat("#,###", "de_DE").format(intKey) + " Credits";
  }
}

/// This is a transfer of credits between to persons

@j.JsonSerializable()
class CreditTransferKey extends IntKey {
  CreditTransferKey(int intKey) : super(intKey);
}

class CreditTransfers extends Table {
  TextColumn get code => text()();
  IntColumn get sender => integer().map(BankAccountKeyConverter())();
  IntColumn get receiver => integer().map(BankAccountKeyConverter())();
  IntColumn get amount => integer()();
}

class BankAccountKeyConverter extends IntKeyConverter<BankAccountKey> {
  @override
  BankAccountKey createKey(int fromDb) => BankAccountKey(fromDb);
}