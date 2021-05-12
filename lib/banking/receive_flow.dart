import 'package:flutter/material.dart';
import 'package:starwars_live/documents/document_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';

class BankingReceiveId extends StatelessWidget {
  final String accountCode;

  const BankingReceiveId({Key? key, required this.accountCode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StarWarsMasterDetailScreen(
      masterTextFactor: 3.0,
      masterChild: Center(
        child: QrScreenContents(
          title: "Empfängerkonto",
          code: accountCode,
        ),
      ),
      detailTextFactor: 2.0,
      detailChildren: [
        StarWarsTextButton(
          text: "Schließen",
          onPressed: () => Navigator.of(context).pop(),
        ),
        StarWarsTextButton(
          text: "Empfangen",
          onPressed: null, // () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
