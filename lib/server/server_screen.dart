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
  late DocumentLevel? idDocumentLevel;

  @override
  Widget build(BuildContext context) {
    if (!_loaded()) {
      SharedPreferences.getInstance().then((preferences) {
        final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT));
        final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
        db.getById(accountKey).then((account) => db.getById((account as Account).personKey).then((person) {
              this.person = person as Person;
              db.getById(person.documentIdKey).then((document) {
                setState(() => idDocumentLevel = (document as Document).level);
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
    return Center(
      child: Table(
        children: [
          TableRow(children: [Text("Vorname"), Text(person.firstName)]),
          TableRow(children: [Text("Nachname"), Text(person.lastName)]),
          TableRow(children: [Text("ID Dokument"), Text(idDocumentLevel!.isValid() ? "gültig" : "Fälschung Stufe " + idDocumentLevel!.level.toString())]),
          TableRow(children: [Text("Scanner"), Text(scannerLevel == 0 ? "N/A" : "Stufe " + scannerLevel.toString())]),
        ], // TODO change password button
      ),
    );
  }

  Widget _getMissing() {
    return Text("Unknown Person");
  }
}
