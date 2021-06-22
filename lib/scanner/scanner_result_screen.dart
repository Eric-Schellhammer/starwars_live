import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/moor_database.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/scanner/scanner_screen.dart';
import 'package:starwars_live/ui_services/scanner_service.dart';
import 'package:starwars_live/ui_services/user_service.dart';

class ScannerResultScreen extends StatefulWidget {
  static const routeName = "/scanner_result_screen";

  ScannerResultScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerResultScreenState();
}

class _ScannerResultScreenState extends State<ScannerResultScreen> {
  ScanResult? result;

  @override
  Widget build(BuildContext context) {
    result = ModalRoute.of(context)?.settings.arguments as ScanResult;
    return StarWarsMasterDetailScreen(
      masterChild: _displayScanResult(),
      detailTextFactor: 2.0,
      detailChildren: [
        StarWarsTextButton(
          text: "Starte Scan",
          onPressed: () => Navigator.of(context).pushReplacementNamed(IdScanScreen.routeName),
        ),
      ],
    );
  }

  Widget _displayScanResult() {
    if (result == null) {
      return Center(child: Text("Noch kein Scan durchgeführt"));
    }
    if (!result!.scannedCodeWasRecognized) {
      return Center(child: Text("Unbekannte ID"));
    }
    final RecognizedPersonScanResult recognizedResult = result as RecognizedPersonScanResult;
    final List<Widget> children = List.empty(growable: true);
    children.add(
      Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text(
          recognizedResult.personName,
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ),
    );

    final Document recognizedDocument = recognizedResult.document;
    children.add(
      Text(recognizedDocument.documentType.name),
    );
    if (recognizedDocument.documentType != DocumentType.PERSONAL_ID && recognizedDocument.information != null && recognizedDocument.information!.isNotEmpty) {
      children.add(
        Text(recognizedDocument.information!),
      ); // TODO make multiline
    }

    String idText;
    Color idColor;
    if (GetIt.instance.get<UserService>().isDocumentValid(recognizedDocument)) {
      idText = "Dokument gültig";
      idColor = Colors.green;
    } else {
      idText = "Dokument ungültig";
      idColor = Colors.red;
    }
    children.add(
      Padding(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: _wrapInBar(idText, idColor),
      ),
    );

    if (recognizedResult.personIsWanted)
      children.add(
        Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: _wrapInBar("GESUCHT!", Colors.red),
        ),
      );

    return Column(children: [
      Expanded(child: Center(child: Text("Kein Bild vorhanden"))),
      DefaultTextStyle(
        style: Theme.of(context).textTheme.apply(fontSizeFactor: 2).bodyText1!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      )
    ]);
  }

  Widget _wrapInBar(String text, Color color) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
      color: color,
    );
  }
}
