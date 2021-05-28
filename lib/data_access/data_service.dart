import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/banking.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';

const String LOGGED_IN_ACCOUNT = "logged-in-account";

abstract class DataService {
  late final StarWarsDb starWarsDb;

  DataService() {
    starWarsDb = StarWarsDb();
  }

  StarWarsDb getDb() {
    return starWarsDb;
  }

  /// returns the Account or null
  Future<Account?> validateAccount(String userName, String password);

  Future<PersonKey> getLoggedInPersonKey();

  Future<Person> getLoggedInPerson();

  Future<int> getCredits(PersonKey personKey);

  Future<ScanResult> resolveScannedDocumentCode(String data);

  Future<ScanResult> resolveScannedBankAccount(String data);

  Future<ScanResult> resolveScannedTransfer(String data);
}

class DataServiceImpl extends DataService {
  @override
  Future<Account?> validateAccount(String userName, String password) async {
    final matches =
        await getDb().getWhere(AccountKey.dbTableKey, (conditions) => conditions.whereEquals(Account.COL_LOGIN_NAME, userName).whereEquals(Account.COL_PASSWORD, password));
    return matches.isEmpty ? null : matches.first;
  }

  @override
  Future<PersonKey> getLoggedInPersonKey() {
    return SharedPreferences.getInstance().then((preferences) {
      final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT)!); // TODO handle missing account
      return getDb().getById(accountKey).then((account) => (account as Account).personKey);
    });
  }

  @override
  Future<Person> getLoggedInPerson() {
    return getLoggedInPersonKey().then((personKey) => getDb().getById(personKey));
  }

  @override
  Future<int> getCredits(PersonKey personKey) {
    return getLoggedInPerson().then((person) => person.bankAccountKey).then((loggedInBankAccount) async {
      int amount = 0;
      final StarWarsDb db = getDb();
      await db
          .getWhere(CreditTransferKey.dbTableKey, (conditions) => conditions.whereEquals(CreditTransfer.COL_RECEIVER_ID, loggedInBankAccount.intKey))
          .then((transfers) => transfers.forEach((transfer) => amount += transfer.amount));
      await db
          .getWhere(CreditTransferKey.dbTableKey, (conditions) => conditions.whereEquals(CreditTransfer.COL_SENDER_ID, loggedInBankAccount.intKey))
          .then((transfers) => transfers.forEach((transfer) => amount -= transfer.amount));
      return amount;
    });
  }

  @override
  Future<ScanResult> resolveScannedDocumentCode(String data) async {
    return getDb().getWhere(DocumentKey.dbTableKey, (conditions) => conditions.whereEquals(Document.COL_CODE, data)).then((documents) {
      if (documents.isEmpty)
        return ScanFailure(errorMessage: "Unbekanntes Dokument");
      else {
        final Document document = documents.first;
        return getDb().getById(document.ownerKey).then((person) => person as Person).then((person) {
          // TODO handle unknown person
          return RecognizedPersonScanResult(
            personName: person.firstName + " " + person.lastName,
            personIsWanted: person.isWanted,
            document: document,
          );
        });
      }
    });
  }

  @override
  Future<ScanResult> resolveScannedBankAccount(String data) {
    return getDb().getSingleWhereOrNull(PersonKey.dbTableKey, (conditions) => conditions.whereEquals(Person.COL_BANK_ACCOUNT_KEY, data)).then((person) {
      if (person != null)
        return RecognizedBankAccount(person.bankAccountKey);
      else
        return ScanFailure(errorMessage: "Unbekanntes Bankkonto");
    });
  }

  @override
  Future<ScanResult> resolveScannedTransfer(String data) async {
    try {
      final Map<String, dynamic> json = jsonDecode(data);
      // validate json format
      if (!json.containsKey(TRANSFER_JSON_RECEIVER) || !json.containsKey(TRANSFER_JSON_SENDER) || !json.containsKey(TRANSFER_JSON_CODE) || !json.containsKey(TRANSFER_JSON_AMOUNT))
        throw ScanException("Daten unvollständig");
      // validate receiver is equal to logged in user
      final BankAccountKey receiverAccountKey = BankAccountKey(json[TRANSFER_JSON_RECEIVER]);
      final BankAccountKey loggedInBankAccountKey = await getLoggedInPerson().then((person) => person.bankAccountKey);
      if (receiverAccountKey != loggedInBankAccountKey) throw ScanException("Falscher Empfänger");
      // validate sender is known
      final db = getDb();
      final List<Person> sender = await db
          .getWhere(PersonKey.dbTableKey, (constraints) => constraints.whereEquals(Person.COL_BANK_ACCOUNT_KEY, json[TRANSFER_JSON_SENDER]))
          .onError((error, stackTrace) => throw ScanException("Unbekannter Absender"));
      final BankAccountKey senderAccountKey = sender.first.bankAccountKey;
      // validate transfer has not been scanned yet
      final String transferCode = json[TRANSFER_JSON_CODE];
      final CreditTransfer? transferByCode =
          await db.getSingleWhereOrNull(CreditTransferKey.dbTableKey, (conditions) => conditions.whereEquals(CreditTransfer.COL_TRANSFER_CODE, transferCode));
      if (transferByCode != null) throw ScanException("Credits wurden bereits übertragen");
      // execute transaction
      final int amount = json[TRANSFER_JSON_AMOUNT];
      await db.insert(CreditTransfer(code: transferCode, sender: senderAccountKey, receiver: receiverAccountKey, amount: amount));
      return ValidTransferScanResult(credits: amount);
    } catch (e) {
      return ScanFailure(errorMessage: (e as ScanException).errorMessage);
    }
  }
}

abstract class ScanResult {
  final bool scannedCodeWasRecognized;

  const ScanResult({this.scannedCodeWasRecognized = false});
}

class ScanSuccess extends ScanResult {
  const ScanSuccess() : super(scannedCodeWasRecognized: true);
}

class ScanFailure extends ScanResult {
  final String errorMessage;

  const ScanFailure({required this.errorMessage}) : super(scannedCodeWasRecognized: false);
}

class RecognizedPersonScanResult extends ScanSuccess {
  final String? image;
  final String personName;
  final bool personIsWanted;
  final Document document;

  const RecognizedPersonScanResult({
    this.image,
    required this.personName,
    required this.personIsWanted,
    required this.document,
  });
}

class RecognizedBankAccount extends ScanSuccess {
  final BankAccountKey bankAccountKey;

  const RecognizedBankAccount(this.bankAccountKey);
}

class ValidTransferScanResult extends ScanSuccess {
  final int credits;

  const ValidTransferScanResult({
    required this.credits,
  });
}

class ScanException implements Exception {
  final String errorMessage;

  const ScanException(this.errorMessage);
}
