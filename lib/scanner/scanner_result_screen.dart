import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/scanner/scan_screen.dart';

class ScannerResultScreen extends StatefulWidget {
  static const routeName = "/scanner_result_screen";

  ScannerResultScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerResultScreenState();
}

class _ScannerResultScreenState extends State<ScannerResultScreen> {
  ScanResult result;

  @override
  Widget build(BuildContext context) {
    result = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: StarWarsMenuFrame(child: _displayScanResult()),
          ),
          Expanded(
            flex: 1,
            child: StarWarsMenuFrame(
              child: Center(
                child: StarWarsButton(
                  child: Text("Starte Scan"),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(ScanScreen.routeName);
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _displayScanResult() {
    if (result == null) {
      return Center(
        child: Text("Noch kein Scan durchgeführt"),
      );
    }
    final List<Widget> children = List();
    children.add(
      Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Text(
          result.personName,
          style: TextStyle(
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );

    children.add(
      Text(_translateDocumentType(result.documentType)),
    );

    if (result.additionalInformation != null &&
        result.additionalInformation.isNotEmpty) {
      children.add(
        Text(result.additionalInformation),
      ); // TODO make multiline
    }

    String idText;
    Color idColor;
    if (result.idIsValid) {
      idText = "ID gültig";
      idColor = Colors.green;
    } else {
      idText = "ID ungültig";
      idColor = Colors.red;
    }
    children.add(
      Padding(
        padding: EdgeInsets.only(top: 8),
        child: _wrapInBar(idText, idColor),
      ),
    );

    if (!result.personIsOk)
      children.add(
        Padding(
          padding: EdgeInsets.only(top: 8),
          child: _wrapInBar("GESUCHT!", Colors.red),
        ),
      );

    return Column(children: [
      Expanded(child: Center(child: Text("Kein Bild vorhanden"))),
      DefaultTextStyle(
        style: Theme.of(context).textTheme.apply(fontSizeFactor: 2).bodyText1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      )
    ]);
  }

  String _translateDocumentType(DocumentType documentType) {
    switch (documentType) {
      case DocumentType.PERSONAL_ID:
        return "Persönliche ID";
      case DocumentType.CAPTAINS_LICENCE:
        return "Kapitänslizenz";
      case DocumentType.VEHICLE_REGISTRATION:
        return "Schiffsregistrierung";
      case DocumentType.WEAPON_LICENCE:
        return "Waffenlizenz";
      case DocumentType.SECTOR_TRADE_LICENCE:
        return "Sektor-Handelslizenz";
      default:
        return "Unbekanntes Dokument";
    }
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
