import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:starwars_live/data_access/moor_database.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';

class DocumentScreen extends StatefulWidget {
  static const String routeName = "/document_screen";

  final Document document;

  const DocumentScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DocumentScreenState();
}

class DocumentScreenState extends State<DocumentScreen> {
  Document get document => widget.document;

  @override
  Widget build(BuildContext context) {
    return DoubleTextSizeTheme(
      child: Scaffold(
        body: StarWarsSwipeToDismissScreen(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Center(child: Text(document.documentType.name)),
                  subtitle: document.information != null
                      ? Center(
                          child: Text(
                          document.information!,
                          style: TextStyle(color: Colors.blue),
                        ))
                      : null,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: QrImage(
                    backgroundColor: Colors.white,
                    data: document.code,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QrScreenContents extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String code;

  const QrScreenContents({Key? key, required this.title, this.subtitle, required this.code}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Center(child: FittedBox(child: Text(title))),
            subtitle: subtitle != null
                ? Center(
                    child: Text(
                    subtitle!,
                    style: TextStyle(color: Colors.blue),
                  ))
                : null,
          ),
          Padding(
            padding: EdgeInsets.only(top: 40),
            child: QrImage(
              backgroundColor: Colors.white,
              data: code,
              version: QrVersions.auto,
              size: 200.0,
            ),
          ),
        ],
      ),
    );
  }
}
