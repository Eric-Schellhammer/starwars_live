import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/temp_storage.dart';
import 'package:starwars_live/documents/document_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/banking.dart';
import 'package:starwars_live/scanner/scanner_screen.dart';

// ignore: camel_case_types
class BankingSendScreen1_ScanReceiver extends StatelessWidget {
  final int maxAmount;

  const BankingSendScreen1_ScanReceiver({Key? key, required this.maxAmount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScannerScreen(
      handleScannedCode: (code) => GetIt.instance.get<DataService>().resolveScannedBankAccount(code),
      handleSuccessfulScan: (context, result) => navigate(context, (result as RecognizedBankAccount).bankAccountKey),
      onCancel: (context) => Navigator.of(context).pop(),
      scanPrompt: "Lese Empfängerkonto ein",
      //testResult: new BankAccountKey(43628).intKey.toString(),
    );
  }

  void navigate(BuildContext context, BankAccountKey receiverBankAccount) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => BankingSendScreen2_EnterAmount(
        maxAmount: maxAmount,
        receiverBankAccount: receiverBankAccount,
      ),
    ));
  }
}

// ignore: camel_case_types
class BankingSendScreen2_EnterAmount extends StatefulWidget {
  final int maxAmount;
  final BankAccountKey receiverBankAccount;

  const BankingSendScreen2_EnterAmount({
    Key? key,
    required this.maxAmount,
    required this.receiverBankAccount,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BankingSendScreen2State();
}

class BankingSendScreen2State extends State<BankingSendScreen2_EnterAmount> {
  late final TextEditingController controller;
  late final Random random;
  late final Future<BankAccountKey> senderBankAccount;
  int amount = 0;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    controller.text = "";
    controller.addListener(() => setState(() {
          amount = int.tryParse(controller.text) ?? 0;
        }));
    random = Random.secure();
    final DataService dataService = GetIt.instance.get<DataService>();
    senderBankAccount = dataService.getLoggedInPerson().then((loggedInPerson) => loggedInPerson.bankAccountKey);
  }

  @override
  Widget build(BuildContext context) {
    return FontScaleTheme(
      factor: 3,
      child: StarWarsMasterDetailScreen(
        masterChild: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(fit: BoxFit.scaleDown, child: Text("Credits zu übertragen:")),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textAlign: TextAlign.end,
              autofocus: true,
              controller: controller,
            ),
          ],
        ),
        detailChildren: [
          StarWarsTextButton(
            text: "Abbrechen",
            onPressed: () => Navigator.of(context).pop(),
          ),
          FutureBuilder<BankAccountKey>(
            future: senderBankAccount,
            builder: (context, snapshot) {
              return StarWarsTextButton(
                text: "Credits abbuchen",
                onPressed: snapshot.hasData && amount > 0 && amount <= widget.maxAmount
                    ? () async {
                        final CreditTransfer creditTransfer = CreditTransfer(
                          code: String.fromCharCodes(List.generate(20, (index) => random.nextInt(33) + 89)),
                          sender: snapshot.data!,
                          receiver: widget.receiverBankAccount,
                          amount: amount,
                        );
                        await GetIt.instance.get<DataService>().getDb().insert(creditTransfer);
                        GetIt.instance.get<TempStorageService>().lastSendTransfer = creditTransfer;
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => BankingSendScreen3_ShowTransfer(creditTransfer: creditTransfer),
                        ));
                      }
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

// ignore: camel_case_types
class BankingSendScreen3_ShowTransfer extends StatelessWidget {
  final CreditTransfer creditTransfer;

  const BankingSendScreen3_ShowTransfer({Key? key, required this.creditTransfer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StarWarsMasterDetailScreen(
      masterTextFactor: 3.0,
      masterChild: Center(
        child: QrScreenContents(
          title: "Transfer",
          code: jsonEncode(creditTransfer),
        ),
      ),
      detailTextFactor: 2.0,
      detailChildren: [
        StarWarsTextButton(
          text: "Fertig",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
