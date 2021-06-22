import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/moor_database.dart';
import 'package:starwars_live/model/banking.dart';
import 'package:starwars_live/ui_services/user_service.dart';

abstract class ScannerService {
  Future<ScanResult> resolveScannedDocumentCode(String data);

  Future<ScanResult> resolveScannedBankAccount(String data);

  Future<ScanResult> resolveScannedTransfer(String data);
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

class ScannerServiceImpl extends ScannerService {
  @override
  Future<ScanResult> resolveScannedDocumentCode(String data) async {
    var dataService = GetIt.instance.get<DataService>();
    return dataService.getDocumentForCode(data).then((document) {
      if (document == null)
        return ScanFailure(errorMessage: "Unbekanntes Dokument");
      else {
        return dataService.getPersonByKey(document.ownerKey).then((person) {
          if (person == null) {
            return ScanFailure(errorMessage: "Unknown Document Owner");
          } else
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
    return GetIt.instance.get<DataService>().getPersonForBankAccount(data).then((person) {
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
      final BankAccountKey loggedInBankAccountKey = await GetIt.instance.get<UserService>().getLoggedInPerson().then((person) => person.bankAccountKey);
      if (receiverAccountKey != loggedInBankAccountKey) throw ScanException("Falscher Empfänger");
      // validate sender is known
      final DataService dataService = GetIt.instance.get<DataService>();
      final Person sender = await dataService.getPersonForBankAccount(json[TRANSFER_JSON_SENDER]).then((person) {
        if (person == null) throw ScanException("Unbekannter Absender");
        return person;
      });
      final BankAccountKey senderAccountKey = sender.bankAccountKey;
      // validate transfer has not been scanned yet
      final String transferCode = json[TRANSFER_JSON_CODE];
      final CreditTransfer? transferByCode = await dataService.getTransferForCode(transferCode);
      if (transferByCode != null) throw ScanException("Credits wurden bereits übertragen");
      // execute transaction
      final int amount = json[TRANSFER_JSON_AMOUNT];
      await dataService.addTransfer(CreditTransfer(code: transferCode, sender: senderAccountKey, receiver: receiverAccountKey, amount: amount));
      return ValidTransferScanResult(credits: amount);
    } catch (e) {
      return ScanFailure(errorMessage: (e as ScanException).errorMessage);
    }
  }
}
