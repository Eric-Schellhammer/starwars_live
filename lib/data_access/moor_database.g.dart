// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Person extends DataClass implements Insertable<Person> {
  final PersonKey id;
  final String firstName;
  final String lastName;
  final ScannerLevel? scannerLevel;
  final DocumentKey documentIdKey;
  final BankAccountKey bankAccountKey;
  final bool hasMedScanner;
  final bool isWanted;
  Person(
      {required this.id,
      required this.firstName,
      required this.lastName,
      this.scannerLevel,
      required this.documentIdKey,
      required this.bankAccountKey,
      required this.hasMedScanner,
      required this.isWanted});
  factory Person.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Person(
      id: $PersonsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      firstName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}first_name'])!,
      lastName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}last_name'])!,
      scannerLevel: $PersonsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}scanner_level'])),
      documentIdKey: $PersonsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}document_id_key']))!,
      bankAccountKey: $PersonsTable.$converter3.mapToDart(const IntType()
          .mapFromDatabaseResponse(
              data['${effectivePrefix}bank_account_key']))!,
      hasMedScanner: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}has_med_scanner'])!,
      isWanted: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}is_wanted'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      final converter = $PersonsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id)!);
    }
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    if (!nullToAbsent || scannerLevel != null) {
      final converter = $PersonsTable.$converter1;
      map['scanner_level'] = Variable<int?>(converter.mapToSql(scannerLevel));
    }
    {
      final converter = $PersonsTable.$converter2;
      map['document_id_key'] =
          Variable<int>(converter.mapToSql(documentIdKey)!);
    }
    {
      final converter = $PersonsTable.$converter3;
      map['bank_account_key'] =
          Variable<int>(converter.mapToSql(bankAccountKey)!);
    }
    map['has_med_scanner'] = Variable<bool>(hasMedScanner);
    map['is_wanted'] = Variable<bool>(isWanted);
    return map;
  }

  PersonsCompanion toCompanion(bool nullToAbsent) {
    return PersonsCompanion(
      id: Value(id),
      firstName: Value(firstName),
      lastName: Value(lastName),
      scannerLevel: scannerLevel == null && nullToAbsent
          ? const Value.absent()
          : Value(scannerLevel),
      documentIdKey: Value(documentIdKey),
      bankAccountKey: Value(bankAccountKey),
      hasMedScanner: Value(hasMedScanner),
      isWanted: Value(isWanted),
    );
  }

  factory Person.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Person(
      id: serializer.fromJson<PersonKey>(json['id']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      scannerLevel: serializer.fromJson<ScannerLevel?>(json['scannerLevel']),
      documentIdKey: serializer.fromJson<DocumentKey>(json['documentIdKey']),
      bankAccountKey:
          serializer.fromJson<BankAccountKey>(json['bankAccountKey']),
      hasMedScanner: serializer.fromJson<bool>(json['hasMedScanner']),
      isWanted: serializer.fromJson<bool>(json['isWanted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<PersonKey>(id),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'scannerLevel': serializer.toJson<ScannerLevel?>(scannerLevel),
      'documentIdKey': serializer.toJson<DocumentKey>(documentIdKey),
      'bankAccountKey': serializer.toJson<BankAccountKey>(bankAccountKey),
      'hasMedScanner': serializer.toJson<bool>(hasMedScanner),
      'isWanted': serializer.toJson<bool>(isWanted),
    };
  }

  Person copyWith(
          {PersonKey? id,
          String? firstName,
          String? lastName,
          ScannerLevel? scannerLevel,
          DocumentKey? documentIdKey,
          BankAccountKey? bankAccountKey,
          bool? hasMedScanner,
          bool? isWanted}) =>
      Person(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        scannerLevel: scannerLevel ?? this.scannerLevel,
        documentIdKey: documentIdKey ?? this.documentIdKey,
        bankAccountKey: bankAccountKey ?? this.bankAccountKey,
        hasMedScanner: hasMedScanner ?? this.hasMedScanner,
        isWanted: isWanted ?? this.isWanted,
      );
  @override
  String toString() {
    return (StringBuffer('Person(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('scannerLevel: $scannerLevel, ')
          ..write('documentIdKey: $documentIdKey, ')
          ..write('bankAccountKey: $bankAccountKey, ')
          ..write('hasMedScanner: $hasMedScanner, ')
          ..write('isWanted: $isWanted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          firstName.hashCode,
          $mrjc(
              lastName.hashCode,
              $mrjc(
                  scannerLevel.hashCode,
                  $mrjc(
                      documentIdKey.hashCode,
                      $mrjc(
                          bankAccountKey.hashCode,
                          $mrjc(
                              hasMedScanner.hashCode, isWanted.hashCode))))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Person &&
          other.id == this.id &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.scannerLevel == this.scannerLevel &&
          other.documentIdKey == this.documentIdKey &&
          other.bankAccountKey == this.bankAccountKey &&
          other.hasMedScanner == this.hasMedScanner &&
          other.isWanted == this.isWanted);
}

class PersonsCompanion extends UpdateCompanion<Person> {
  final Value<PersonKey> id;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<ScannerLevel?> scannerLevel;
  final Value<DocumentKey> documentIdKey;
  final Value<BankAccountKey> bankAccountKey;
  final Value<bool> hasMedScanner;
  final Value<bool> isWanted;
  const PersonsCompanion({
    this.id = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.scannerLevel = const Value.absent(),
    this.documentIdKey = const Value.absent(),
    this.bankAccountKey = const Value.absent(),
    this.hasMedScanner = const Value.absent(),
    this.isWanted = const Value.absent(),
  });
  PersonsCompanion.insert({
    required PersonKey id,
    required String firstName,
    required String lastName,
    this.scannerLevel = const Value.absent(),
    required DocumentKey documentIdKey,
    required BankAccountKey bankAccountKey,
    this.hasMedScanner = const Value.absent(),
    this.isWanted = const Value.absent(),
  })  : id = Value(id),
        firstName = Value(firstName),
        lastName = Value(lastName),
        documentIdKey = Value(documentIdKey),
        bankAccountKey = Value(bankAccountKey);
  static Insertable<Person> custom({
    Expression<PersonKey>? id,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<ScannerLevel?>? scannerLevel,
    Expression<DocumentKey>? documentIdKey,
    Expression<BankAccountKey>? bankAccountKey,
    Expression<bool>? hasMedScanner,
    Expression<bool>? isWanted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (scannerLevel != null) 'scanner_level': scannerLevel,
      if (documentIdKey != null) 'document_id_key': documentIdKey,
      if (bankAccountKey != null) 'bank_account_key': bankAccountKey,
      if (hasMedScanner != null) 'has_med_scanner': hasMedScanner,
      if (isWanted != null) 'is_wanted': isWanted,
    });
  }

  PersonsCompanion copyWith(
      {Value<PersonKey>? id,
      Value<String>? firstName,
      Value<String>? lastName,
      Value<ScannerLevel?>? scannerLevel,
      Value<DocumentKey>? documentIdKey,
      Value<BankAccountKey>? bankAccountKey,
      Value<bool>? hasMedScanner,
      Value<bool>? isWanted}) {
    return PersonsCompanion(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      scannerLevel: scannerLevel ?? this.scannerLevel,
      documentIdKey: documentIdKey ?? this.documentIdKey,
      bankAccountKey: bankAccountKey ?? this.bankAccountKey,
      hasMedScanner: hasMedScanner ?? this.hasMedScanner,
      isWanted: isWanted ?? this.isWanted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $PersonsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (scannerLevel.present) {
      final converter = $PersonsTable.$converter1;
      map['scanner_level'] =
          Variable<int?>(converter.mapToSql(scannerLevel.value));
    }
    if (documentIdKey.present) {
      final converter = $PersonsTable.$converter2;
      map['document_id_key'] =
          Variable<int>(converter.mapToSql(documentIdKey.value)!);
    }
    if (bankAccountKey.present) {
      final converter = $PersonsTable.$converter3;
      map['bank_account_key'] =
          Variable<int>(converter.mapToSql(bankAccountKey.value)!);
    }
    if (hasMedScanner.present) {
      map['has_med_scanner'] = Variable<bool>(hasMedScanner.value);
    }
    if (isWanted.present) {
      map['is_wanted'] = Variable<bool>(isWanted.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonsCompanion(')
          ..write('id: $id, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('scannerLevel: $scannerLevel, ')
          ..write('documentIdKey: $documentIdKey, ')
          ..write('bankAccountKey: $bankAccountKey, ')
          ..write('hasMedScanner: $hasMedScanner, ')
          ..write('isWanted: $isWanted')
          ..write(')'))
        .toString();
  }
}

class $PersonsTable extends Persons with TableInfo<$PersonsTable, Person> {
  final GeneratedDatabase _db;
  final String? _alias;
  $PersonsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _firstNameMeta = const VerificationMeta('firstName');
  @override
  late final GeneratedTextColumn firstName = _constructFirstName();
  GeneratedTextColumn _constructFirstName() {
    return GeneratedTextColumn(
      'first_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _lastNameMeta = const VerificationMeta('lastName');
  @override
  late final GeneratedTextColumn lastName = _constructLastName();
  GeneratedTextColumn _constructLastName() {
    return GeneratedTextColumn(
      'last_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _scannerLevelMeta =
      const VerificationMeta('scannerLevel');
  @override
  late final GeneratedIntColumn scannerLevel = _constructScannerLevel();
  GeneratedIntColumn _constructScannerLevel() {
    return GeneratedIntColumn(
      'scanner_level',
      $tableName,
      true,
    );
  }

  final VerificationMeta _documentIdKeyMeta =
      const VerificationMeta('documentIdKey');
  @override
  late final GeneratedIntColumn documentIdKey = _constructDocumentIdKey();
  GeneratedIntColumn _constructDocumentIdKey() {
    return GeneratedIntColumn(
      'document_id_key',
      $tableName,
      false,
    );
  }

  final VerificationMeta _bankAccountKeyMeta =
      const VerificationMeta('bankAccountKey');
  @override
  late final GeneratedIntColumn bankAccountKey = _constructBankAccountKey();
  GeneratedIntColumn _constructBankAccountKey() {
    return GeneratedIntColumn(
      'bank_account_key',
      $tableName,
      false,
    );
  }

  final VerificationMeta _hasMedScannerMeta =
      const VerificationMeta('hasMedScanner');
  @override
  late final GeneratedBoolColumn hasMedScanner = _constructHasMedScanner();
  GeneratedBoolColumn _constructHasMedScanner() {
    return GeneratedBoolColumn('has_med_scanner', $tableName, false,
        defaultValue: const Constant(false));
  }

  final VerificationMeta _isWantedMeta = const VerificationMeta('isWanted');
  @override
  late final GeneratedBoolColumn isWanted = _constructIsWanted();
  GeneratedBoolColumn _constructIsWanted() {
    return GeneratedBoolColumn('is_wanted', $tableName, false,
        defaultValue: const Constant(false));
  }

  @override
  List<GeneratedColumn> get $columns => [
        id,
        firstName,
        lastName,
        scannerLevel,
        documentIdKey,
        bankAccountKey,
        hasMedScanner,
        isWanted
      ];
  @override
  $PersonsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'persons';
  @override
  final String actualTableName = 'persons';
  @override
  VerificationContext validateIntegrity(Insertable<Person> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    if (data.containsKey('first_name')) {
      context.handle(_firstNameMeta,
          firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta));
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(_lastNameMeta,
          lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta));
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    context.handle(_scannerLevelMeta, const VerificationResult.success());
    context.handle(_documentIdKeyMeta, const VerificationResult.success());
    context.handle(_bankAccountKeyMeta, const VerificationResult.success());
    if (data.containsKey('has_med_scanner')) {
      context.handle(
          _hasMedScannerMeta,
          hasMedScanner.isAcceptableOrUnknown(
              data['has_med_scanner']!, _hasMedScannerMeta));
    }
    if (data.containsKey('is_wanted')) {
      context.handle(_isWantedMeta,
          isWanted.isAcceptableOrUnknown(data['is_wanted']!, _isWantedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Person map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Person.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $PersonsTable createAlias(String alias) {
    return $PersonsTable(_db, alias);
  }

  static TypeConverter<PersonKey, int> $converter0 = PersonKeyConverter();
  static TypeConverter<ScannerLevel, int> $converter1 = ScannerLevelConverter();
  static TypeConverter<DocumentKey, int> $converter2 = DocumentKeyConverter();
  static TypeConverter<BankAccountKey, int> $converter3 =
      BankAccountKeyConverter();
}

class Account extends DataClass implements Insertable<Account> {
  final AccountKey key;
  final String loginName;
  final String password;
  final PersonKey personKey;
  Account(
      {required this.key,
      required this.loginName,
      required this.password,
      required this.personKey});
  factory Account.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Account(
      key: $AccountsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}key']))!,
      loginName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}login_name'])!,
      password: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}password'])!,
      personKey: $AccountsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}person_key']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      final converter = $AccountsTable.$converter0;
      map['key'] = Variable<int>(converter.mapToSql(key)!);
    }
    map['login_name'] = Variable<String>(loginName);
    map['password'] = Variable<String>(password);
    {
      final converter = $AccountsTable.$converter1;
      map['person_key'] = Variable<int>(converter.mapToSql(personKey)!);
    }
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      key: Value(key),
      loginName: Value(loginName),
      password: Value(password),
      personKey: Value(personKey),
    );
  }

  factory Account.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Account(
      key: serializer.fromJson<AccountKey>(json['key']),
      loginName: serializer.fromJson<String>(json['loginName']),
      password: serializer.fromJson<String>(json['password']),
      personKey: serializer.fromJson<PersonKey>(json['personKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<AccountKey>(key),
      'loginName': serializer.toJson<String>(loginName),
      'password': serializer.toJson<String>(password),
      'personKey': serializer.toJson<PersonKey>(personKey),
    };
  }

  Account copyWith(
          {AccountKey? key,
          String? loginName,
          String? password,
          PersonKey? personKey}) =>
      Account(
        key: key ?? this.key,
        loginName: loginName ?? this.loginName,
        password: password ?? this.password,
        personKey: personKey ?? this.personKey,
      );
  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('key: $key, ')
          ..write('loginName: $loginName, ')
          ..write('password: $password, ')
          ..write('personKey: $personKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(key.hashCode,
      $mrjc(loginName.hashCode, $mrjc(password.hashCode, personKey.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.key == this.key &&
          other.loginName == this.loginName &&
          other.password == this.password &&
          other.personKey == this.personKey);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<AccountKey> key;
  final Value<String> loginName;
  final Value<String> password;
  final Value<PersonKey> personKey;
  const AccountsCompanion({
    this.key = const Value.absent(),
    this.loginName = const Value.absent(),
    this.password = const Value.absent(),
    this.personKey = const Value.absent(),
  });
  AccountsCompanion.insert({
    required AccountKey key,
    required String loginName,
    required String password,
    required PersonKey personKey,
  })  : key = Value(key),
        loginName = Value(loginName),
        password = Value(password),
        personKey = Value(personKey);
  static Insertable<Account> custom({
    Expression<AccountKey>? key,
    Expression<String>? loginName,
    Expression<String>? password,
    Expression<PersonKey>? personKey,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (loginName != null) 'login_name': loginName,
      if (password != null) 'password': password,
      if (personKey != null) 'person_key': personKey,
    });
  }

  AccountsCompanion copyWith(
      {Value<AccountKey>? key,
      Value<String>? loginName,
      Value<String>? password,
      Value<PersonKey>? personKey}) {
    return AccountsCompanion(
      key: key ?? this.key,
      loginName: loginName ?? this.loginName,
      password: password ?? this.password,
      personKey: personKey ?? this.personKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      final converter = $AccountsTable.$converter0;
      map['key'] = Variable<int>(converter.mapToSql(key.value)!);
    }
    if (loginName.present) {
      map['login_name'] = Variable<String>(loginName.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (personKey.present) {
      final converter = $AccountsTable.$converter1;
      map['person_key'] = Variable<int>(converter.mapToSql(personKey.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('key: $key, ')
          ..write('loginName: $loginName, ')
          ..write('password: $password, ')
          ..write('personKey: $personKey')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  final GeneratedDatabase _db;
  final String? _alias;
  $AccountsTable(this._db, [this._alias]);
  final VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedIntColumn key = _constructKey();
  GeneratedIntColumn _constructKey() {
    return GeneratedIntColumn(
      'key',
      $tableName,
      false,
    );
  }

  final VerificationMeta _loginNameMeta = const VerificationMeta('loginName');
  @override
  late final GeneratedTextColumn loginName = _constructLoginName();
  GeneratedTextColumn _constructLoginName() {
    return GeneratedTextColumn(
      'login_name',
      $tableName,
      false,
    );
  }

  final VerificationMeta _passwordMeta = const VerificationMeta('password');
  @override
  late final GeneratedTextColumn password = _constructPassword();
  GeneratedTextColumn _constructPassword() {
    return GeneratedTextColumn(
      'password',
      $tableName,
      false,
    );
  }

  final VerificationMeta _personKeyMeta = const VerificationMeta('personKey');
  @override
  late final GeneratedIntColumn personKey = _constructPersonKey();
  GeneratedIntColumn _constructPersonKey() {
    return GeneratedIntColumn(
      'person_key',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [key, loginName, password, personKey];
  @override
  $AccountsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'accounts';
  @override
  final String actualTableName = 'accounts';
  @override
  VerificationContext validateIntegrity(Insertable<Account> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_keyMeta, const VerificationResult.success());
    if (data.containsKey('login_name')) {
      context.handle(_loginNameMeta,
          loginName.isAcceptableOrUnknown(data['login_name']!, _loginNameMeta));
    } else if (isInserting) {
      context.missing(_loginNameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(_passwordMeta,
          password.isAcceptableOrUnknown(data['password']!, _passwordMeta));
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    context.handle(_personKeyMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Account.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(_db, alias);
  }

  static TypeConverter<AccountKey, int> $converter0 = AccountKeyConverter();
  static TypeConverter<PersonKey, int> $converter1 = PersonKeyConverter();
}

class CreditTransfer extends DataClass implements Insertable<CreditTransfer> {
  final String code;
  final BankAccountKey sender;
  final BankAccountKey receiver;
  final int amount;
  CreditTransfer(
      {required this.code,
      required this.sender,
      required this.receiver,
      required this.amount});
  factory CreditTransfer.fromData(
      Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CreditTransfer(
      code: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}code'])!,
      sender: $CreditTransfersTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sender']))!,
      receiver: $CreditTransfersTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}receiver']))!,
      amount: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}amount'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['code'] = Variable<String>(code);
    {
      final converter = $CreditTransfersTable.$converter0;
      map['sender'] = Variable<int>(converter.mapToSql(sender)!);
    }
    {
      final converter = $CreditTransfersTable.$converter1;
      map['receiver'] = Variable<int>(converter.mapToSql(receiver)!);
    }
    map['amount'] = Variable<int>(amount);
    return map;
  }

  CreditTransfersCompanion toCompanion(bool nullToAbsent) {
    return CreditTransfersCompanion(
      code: Value(code),
      sender: Value(sender),
      receiver: Value(receiver),
      amount: Value(amount),
    );
  }

  factory CreditTransfer.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return CreditTransfer(
      code: serializer.fromJson<String>(json['code']),
      sender: serializer.fromJson<BankAccountKey>(json['sender']),
      receiver: serializer.fromJson<BankAccountKey>(json['receiver']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'code': serializer.toJson<String>(code),
      'sender': serializer.toJson<BankAccountKey>(sender),
      'receiver': serializer.toJson<BankAccountKey>(receiver),
      'amount': serializer.toJson<int>(amount),
    };
  }

  CreditTransfer copyWith(
          {String? code,
          BankAccountKey? sender,
          BankAccountKey? receiver,
          int? amount}) =>
      CreditTransfer(
        code: code ?? this.code,
        sender: sender ?? this.sender,
        receiver: receiver ?? this.receiver,
        amount: amount ?? this.amount,
      );
  @override
  String toString() {
    return (StringBuffer('CreditTransfer(')
          ..write('code: $code, ')
          ..write('sender: $sender, ')
          ..write('receiver: $receiver, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(code.hashCode,
      $mrjc(sender.hashCode, $mrjc(receiver.hashCode, amount.hashCode))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditTransfer &&
          other.code == this.code &&
          other.sender == this.sender &&
          other.receiver == this.receiver &&
          other.amount == this.amount);
}

class CreditTransfersCompanion extends UpdateCompanion<CreditTransfer> {
  final Value<String> code;
  final Value<BankAccountKey> sender;
  final Value<BankAccountKey> receiver;
  final Value<int> amount;
  const CreditTransfersCompanion({
    this.code = const Value.absent(),
    this.sender = const Value.absent(),
    this.receiver = const Value.absent(),
    this.amount = const Value.absent(),
  });
  CreditTransfersCompanion.insert({
    required String code,
    required BankAccountKey sender,
    required BankAccountKey receiver,
    required int amount,
  })  : code = Value(code),
        sender = Value(sender),
        receiver = Value(receiver),
        amount = Value(amount);
  static Insertable<CreditTransfer> custom({
    Expression<String>? code,
    Expression<BankAccountKey>? sender,
    Expression<BankAccountKey>? receiver,
    Expression<int>? amount,
  }) {
    return RawValuesInsertable({
      if (code != null) 'code': code,
      if (sender != null) 'sender': sender,
      if (receiver != null) 'receiver': receiver,
      if (amount != null) 'amount': amount,
    });
  }

  CreditTransfersCompanion copyWith(
      {Value<String>? code,
      Value<BankAccountKey>? sender,
      Value<BankAccountKey>? receiver,
      Value<int>? amount}) {
    return CreditTransfersCompanion(
      code: code ?? this.code,
      sender: sender ?? this.sender,
      receiver: receiver ?? this.receiver,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (sender.present) {
      final converter = $CreditTransfersTable.$converter0;
      map['sender'] = Variable<int>(converter.mapToSql(sender.value)!);
    }
    if (receiver.present) {
      final converter = $CreditTransfersTable.$converter1;
      map['receiver'] = Variable<int>(converter.mapToSql(receiver.value)!);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditTransfersCompanion(')
          ..write('code: $code, ')
          ..write('sender: $sender, ')
          ..write('receiver: $receiver, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

class $CreditTransfersTable extends CreditTransfers
    with TableInfo<$CreditTransfersTable, CreditTransfer> {
  final GeneratedDatabase _db;
  final String? _alias;
  $CreditTransfersTable(this._db, [this._alias]);
  final VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedTextColumn code = _constructCode();
  GeneratedTextColumn _constructCode() {
    return GeneratedTextColumn(
      'code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _senderMeta = const VerificationMeta('sender');
  @override
  late final GeneratedIntColumn sender = _constructSender();
  GeneratedIntColumn _constructSender() {
    return GeneratedIntColumn(
      'sender',
      $tableName,
      false,
    );
  }

  final VerificationMeta _receiverMeta = const VerificationMeta('receiver');
  @override
  late final GeneratedIntColumn receiver = _constructReceiver();
  GeneratedIntColumn _constructReceiver() {
    return GeneratedIntColumn(
      'receiver',
      $tableName,
      false,
    );
  }

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedIntColumn amount = _constructAmount();
  GeneratedIntColumn _constructAmount() {
    return GeneratedIntColumn(
      'amount',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns => [code, sender, receiver, amount];
  @override
  $CreditTransfersTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'credit_transfers';
  @override
  final String actualTableName = 'credit_transfers';
  @override
  VerificationContext validateIntegrity(Insertable<CreditTransfer> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    context.handle(_senderMeta, const VerificationResult.success());
    context.handle(_receiverMeta, const VerificationResult.success());
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  CreditTransfer map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CreditTransfer.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CreditTransfersTable createAlias(String alias) {
    return $CreditTransfersTable(_db, alias);
  }

  static TypeConverter<BankAccountKey, int> $converter0 =
      BankAccountKeyConverter();
  static TypeConverter<BankAccountKey, int> $converter1 =
      BankAccountKeyConverter();
}

class Document extends DataClass implements Insertable<Document> {
  final DocumentKey id;
  final String code;
  final PersonKey ownerKey;
  final DocumentType documentType;
  final String? information;
  final DocumentLevel level;
  Document(
      {required this.id,
      required this.code,
      required this.ownerKey,
      required this.documentType,
      this.information,
      required this.level});
  factory Document.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Document(
      id: $DocumentsTable.$converter0.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id']))!,
      code: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}code'])!,
      ownerKey: $DocumentsTable.$converter1.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}owner_key']))!,
      documentType: $DocumentsTable.$converter2.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}document_type']))!,
      information: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}information']),
      level: $DocumentsTable.$converter3.mapToDart(const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}level']))!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    {
      final converter = $DocumentsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id)!);
    }
    map['code'] = Variable<String>(code);
    {
      final converter = $DocumentsTable.$converter1;
      map['owner_key'] = Variable<int>(converter.mapToSql(ownerKey)!);
    }
    {
      final converter = $DocumentsTable.$converter2;
      map['document_type'] = Variable<int>(converter.mapToSql(documentType)!);
    }
    if (!nullToAbsent || information != null) {
      map['information'] = Variable<String?>(information);
    }
    {
      final converter = $DocumentsTable.$converter3;
      map['level'] = Variable<int>(converter.mapToSql(level)!);
    }
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      code: Value(code),
      ownerKey: Value(ownerKey),
      documentType: Value(documentType),
      information: information == null && nullToAbsent
          ? const Value.absent()
          : Value(information),
      level: Value(level),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<DocumentKey>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      ownerKey: serializer.fromJson<PersonKey>(json['ownerKey']),
      documentType: serializer.fromJson<DocumentType>(json['documentType']),
      information: serializer.fromJson<String?>(json['information']),
      level: serializer.fromJson<DocumentLevel>(json['level']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<DocumentKey>(id),
      'code': serializer.toJson<String>(code),
      'ownerKey': serializer.toJson<PersonKey>(ownerKey),
      'documentType': serializer.toJson<DocumentType>(documentType),
      'information': serializer.toJson<String?>(information),
      'level': serializer.toJson<DocumentLevel>(level),
    };
  }

  Document copyWith(
          {DocumentKey? id,
          String? code,
          PersonKey? ownerKey,
          DocumentType? documentType,
          String? information,
          DocumentLevel? level}) =>
      Document(
        id: id ?? this.id,
        code: code ?? this.code,
        ownerKey: ownerKey ?? this.ownerKey,
        documentType: documentType ?? this.documentType,
        information: information ?? this.information,
        level: level ?? this.level,
      );
  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('ownerKey: $ownerKey, ')
          ..write('documentType: $documentType, ')
          ..write('information: $information, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          code.hashCode,
          $mrjc(
              ownerKey.hashCode,
              $mrjc(documentType.hashCode,
                  $mrjc(information.hashCode, level.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.code == this.code &&
          other.ownerKey == this.ownerKey &&
          other.documentType == this.documentType &&
          other.information == this.information &&
          other.level == this.level);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<DocumentKey> id;
  final Value<String> code;
  final Value<PersonKey> ownerKey;
  final Value<DocumentType> documentType;
  final Value<String?> information;
  final Value<DocumentLevel> level;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.ownerKey = const Value.absent(),
    this.documentType = const Value.absent(),
    this.information = const Value.absent(),
    this.level = const Value.absent(),
  });
  DocumentsCompanion.insert({
    required DocumentKey id,
    required String code,
    required PersonKey ownerKey,
    required DocumentType documentType,
    this.information = const Value.absent(),
    required DocumentLevel level,
  })  : id = Value(id),
        code = Value(code),
        ownerKey = Value(ownerKey),
        documentType = Value(documentType),
        level = Value(level);
  static Insertable<Document> custom({
    Expression<DocumentKey>? id,
    Expression<String>? code,
    Expression<PersonKey>? ownerKey,
    Expression<DocumentType>? documentType,
    Expression<String?>? information,
    Expression<DocumentLevel>? level,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (ownerKey != null) 'owner_key': ownerKey,
      if (documentType != null) 'document_type': documentType,
      if (information != null) 'information': information,
      if (level != null) 'level': level,
    });
  }

  DocumentsCompanion copyWith(
      {Value<DocumentKey>? id,
      Value<String>? code,
      Value<PersonKey>? ownerKey,
      Value<DocumentType>? documentType,
      Value<String?>? information,
      Value<DocumentLevel>? level}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      ownerKey: ownerKey ?? this.ownerKey,
      documentType: documentType ?? this.documentType,
      information: information ?? this.information,
      level: level ?? this.level,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      final converter = $DocumentsTable.$converter0;
      map['id'] = Variable<int>(converter.mapToSql(id.value)!);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (ownerKey.present) {
      final converter = $DocumentsTable.$converter1;
      map['owner_key'] = Variable<int>(converter.mapToSql(ownerKey.value)!);
    }
    if (documentType.present) {
      final converter = $DocumentsTable.$converter2;
      map['document_type'] =
          Variable<int>(converter.mapToSql(documentType.value)!);
    }
    if (information.present) {
      map['information'] = Variable<String?>(information.value);
    }
    if (level.present) {
      final converter = $DocumentsTable.$converter3;
      map['level'] = Variable<int>(converter.mapToSql(level.value)!);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('ownerKey: $ownerKey, ')
          ..write('documentType: $documentType, ')
          ..write('information: $information, ')
          ..write('level: $level')
          ..write(')'))
        .toString();
  }
}

class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DocumentsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedIntColumn id = _constructId();
  GeneratedIntColumn _constructId() {
    return GeneratedIntColumn(
      'id',
      $tableName,
      false,
    );
  }

  final VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedTextColumn code = _constructCode();
  GeneratedTextColumn _constructCode() {
    return GeneratedTextColumn(
      'code',
      $tableName,
      false,
    );
  }

  final VerificationMeta _ownerKeyMeta = const VerificationMeta('ownerKey');
  @override
  late final GeneratedIntColumn ownerKey = _constructOwnerKey();
  GeneratedIntColumn _constructOwnerKey() {
    return GeneratedIntColumn(
      'owner_key',
      $tableName,
      false,
    );
  }

  final VerificationMeta _documentTypeMeta =
      const VerificationMeta('documentType');
  @override
  late final GeneratedIntColumn documentType = _constructDocumentType();
  GeneratedIntColumn _constructDocumentType() {
    return GeneratedIntColumn(
      'document_type',
      $tableName,
      false,
    );
  }

  final VerificationMeta _informationMeta =
      const VerificationMeta('information');
  @override
  late final GeneratedTextColumn information = _constructInformation();
  GeneratedTextColumn _constructInformation() {
    return GeneratedTextColumn(
      'information',
      $tableName,
      true,
    );
  }

  final VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedIntColumn level = _constructLevel();
  GeneratedIntColumn _constructLevel() {
    return GeneratedIntColumn(
      'level',
      $tableName,
      false,
    );
  }

  @override
  List<GeneratedColumn> get $columns =>
      [id, code, ownerKey, documentType, information, level];
  @override
  $DocumentsTable get asDslTable => this;
  @override
  String get $tableName => _alias ?? 'documents';
  @override
  final String actualTableName = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    context.handle(_idMeta, const VerificationResult.success());
    if (data.containsKey('code')) {
      context.handle(
          _codeMeta, code.isAcceptableOrUnknown(data['code']!, _codeMeta));
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    context.handle(_ownerKeyMeta, const VerificationResult.success());
    context.handle(_documentTypeMeta, const VerificationResult.success());
    if (data.containsKey('information')) {
      context.handle(
          _informationMeta,
          information.isAcceptableOrUnknown(
              data['information']!, _informationMeta));
    }
    context.handle(_levelMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => <GeneratedColumn>{};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Document.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(_db, alias);
  }

  static TypeConverter<DocumentKey, int> $converter0 = DocumentKeyConverter();
  static TypeConverter<PersonKey, int> $converter1 = PersonKeyConverter();
  static TypeConverter<DocumentType, int> $converter2 = DocumentTypeConverter();
  static TypeConverter<DocumentLevel, int> $converter3 =
      DocumentLevelConverter();
}

abstract class _$StarWarsDb extends GeneratedDatabase {
  _$StarWarsDb(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $PersonsTable persons = $PersonsTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CreditTransfersTable creditTransfers =
      $CreditTransfersTable(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [persons, accounts, creditTransfers, documents];
}
