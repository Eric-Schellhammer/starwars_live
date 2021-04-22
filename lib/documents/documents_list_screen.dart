import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';

class DocumentsListScreen extends StatefulWidget {
  static const String routeName = "/documents_list_screen";

  @override
  State<StatefulWidget> createState() => DocumentsListScreenState();
}

class DocumentsListScreenState extends State<DocumentsListScreen> {
  List<Document>? documents;

  @override
  Widget build(BuildContext context) {
    if (!_loaded()) {
      SharedPreferences.getInstance().then((preferences) {
        final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT));
        final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
        db.getById(accountKey).then((account) => db.getById((account as Account).personKey).then((person) => (person as Person).getKey().intKey).then((personKey) => db
                .getWhere(DocumentKey.dbTableKey,
                    (conditions) => conditions.whereEquals(Document.COL_OWNER, personKey).whereNotEquals(Document.COL_TYPE, DocumentType.PERSONAL_ID.intKey))
                .then((documents) {
              setState(() {
                this.documents = documents;
              });
            })));
      });
      return Scaffold(body: Center(child: Text("Kontaktiere Server...")));
    }

    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
      child: Scaffold(
        body: StarWarsSwipeToDismissScreen(
          child: _getDocumentsList(),
        ),
      ),
    );
  }

  bool _loaded() {
    return documents != null;
  }

  Widget _getDocumentsList() {
    if (documents!.isEmpty) return Center(child: Text("Keine Dokumente vorhanden."));
    return ListView(
      children: documents!
          .map((document) => ListTile(
                title: StarWarsMenuFrame(child: Text(document.type.name.toString())), // TODO display document details
              ))
          .toList(),
    );
  }

  Widget _getIdCode(String code) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Personal ID:"),
          QrImage(
            backgroundColor: Colors.white,
            data: code,
            version: QrVersions.auto,
            size: 200.0,
          ),
        ],
      ),
    );
  }
}
