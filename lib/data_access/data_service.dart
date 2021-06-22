import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';

import 'moor_database.dart';

abstract class DataService {
  /// returns the Account or null
  Future<Account?> validateAccount(String userName, String password);

  /* PERSON */

  Future<Account?> getAccountByKey(AccountKey accountKey);

  Future<Person?> getPersonByKey(PersonKey personKey);

  Future<Person?> getPersonForBankAccount(String accountKeyAsString);

  /* CREDITS */

  Future<int> getCredits(PersonKey personKey);

  Future<CreditTransfer?> getTransferForCode(String code);

  Future<void> addTransfer(CreditTransfer creditTransfer);

  /* DOCUMENTS */

  Future<List<Document>> getDocumentsOfPerson(PersonKey personKey);

  Future<Document?> getDocumentByKey(DocumentKey documentKey);

  Future<Document?> getDocumentForCode(String code);

  /* IM- AND EXPORT */

  Future<String> getExport();

  Future<void> setImport(String jsonString);
}
