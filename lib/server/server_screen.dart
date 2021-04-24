import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

class ServerScreen extends StatefulWidget {
  static const routeName = "/server_screen";

  @override
  State<StatefulWidget> createState() => ServerScreenState();
}

class ServerScreenState extends State<ServerScreen> {
  Person? person;
  DocumentLevel? idDocumentLevel;
  List<Document>? documents;

  @override
  Widget build(BuildContext context) {
    if (!_loaded()) {
      SharedPreferences.getInstance().then((preferences) {
        final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT));
        final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
        db.getById(accountKey).then((account) => db.getById((account as Account).personKey).then((person) {
              this.person = person as Person;
              db.getWhere(DocumentKey.dbTableKey, (conditions) => conditions.whereEquals(Document.COL_OWNER, person.key.intKey)).then((documents) {
                setState(() {
                  this.documents = documents.where((document) => document.type != DocumentType.PERSONAL_ID).toList(growable: false);
                  idDocumentLevel = documents.where((document) => document.type == DocumentType.PERSONAL_ID).first.level;
                });
              });
            }));
      });
      return Scaffold(body: Center(child: Text("Kontaktiere Server...")));
    }

    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
      child: Scaffold(
        body: StarWarsSwipeToDismissScreen(
          child: person != null ? _getForPerson(person!) : _getMissing(),
        ),
      ),
    );
  }

  bool _loaded() {
    return person != null && idDocumentLevel != null;
  }

  Widget _getForPerson(Person person) {
    int scannerLevel = person.scannerLevel?.level ?? 0;
    final List<TableRow> children = [
      TableRow(children: [Text("Vorname"), Text(person.firstName)]),
      TableRow(children: [Text("Nachname"), Text(person.lastName)]),
      TableRow(children: [Text("ID Dokument"), _getValidity(idDocumentLevel!)]),
      TableRow(children: [Text("Scanner"), Text(scannerLevel == 0 ? "N/A" : "Stufe " + scannerLevel.toString())]),
    ].toList();
    documents!.forEach((document) {
      children.add(
        TableRow(children: [Text(document.type.name), _getValidity(document.level)]),
      );
    });
    return Center(
      child: Table(
        children: children, // TODO change password button
      ),
    );
  }

  Widget _getValidity(DocumentLevel level) {
    return Text(level.isValid() ? "gültig" : "Fälschung Stufe " + level.level.toString());
  }

  Widget _getMissing() {
    return Text("Unknown Person");
  }
}
