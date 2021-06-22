import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/documents/document_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/banking.dart';
import 'package:starwars_live/scanner/scanner_screen.dart';
import 'package:starwars_live/ui_services/scanner_service.dart';
import 'package:starwars_live/ui_services/user_service.dart';

// ignore: camel_case_types
class BankingReceiveScreen1_ShowReceiveId extends StatelessWidget {
  final Future<BankAccountKey> bankAccountKeyFuture = GetIt.instance.get<UserService>().getLoggedInPerson().then((person) => person.bankAccountKey);

  @override
  Widget build(BuildContext context) {
    return StarWarsMasterDetailScreen(
      masterTextFactor: 3.0,
      masterChild: Center(
        child: FutureBuilder<BankAccountKey>(
            future: bankAccountKeyFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return QrScreenContents(
                  title: "Empfängerkonto",
                  code: snapshot.data!.intKey.toString(),
                );
              return Text("Kontaktiere Server...");
            }),
      ),
      detailTextFactor: 2.0,
      detailChildren: [
        StarWarsTextButton(
          text: "Schließen",
          onPressed: () => Navigator.of(context).pop(),
        ),
        StarWarsTextButton(
          text: "Empfangen",
          onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BankingReceiveScreen2_ScanTransfer())),
        ),
      ],
    );
  }
}

// ignore: camel_case_types
class BankingReceiveScreen2_ScanTransfer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScannerScreen(
      handleScannedCode: (code) => GetIt.instance.get<ScannerService>().resolveScannedTransfer(code),
      handleSuccessfulScan: (context, result) => Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => BankingReceiveScreen3_ShowResult(result: result as ValidTransferScanResult),
      )),
      onCancel: (context) => Navigator.of(context).pop(),
      scanPrompt: "Lese Transfer ein",
      //testResult: fakeTransfer(),
    );
  }
}

// ignore: camel_case_types
class BankingReceiveScreen3_ShowResult extends StatelessWidget {
  final ValidTransferScanResult result;

  const BankingReceiveScreen3_ShowResult({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FontScaleTheme(
      factor: 3,
      child: StarWarsSwipeToDismissScreen(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FittedBox(fit: BoxFit.scaleDown, child: Text(BankBalance(result.credits).toString())),
              Text("empfangen."),
            ],
          ),
        ),
      ),
    );
  }
}
