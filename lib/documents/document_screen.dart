import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/document.dart';

class DocumentScreen extends StatefulWidget {
  static const String routeName = "/document_screen";

  final Document document;

  const DocumentScreen({Key? key, required this.document}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DocumentScreenState();
}

class DocumentScreenState extends State<DocumentScreen> {
  get document => widget.document;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
      child: Scaffold(
        body: StarWarsSwipeToDismissScreen(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Center(child: Text(document.type.name)),
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
