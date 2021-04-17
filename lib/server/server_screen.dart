import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/model/validation.dart';

class ServerScreen extends StatefulWidget {
  static const routeName = "/server_screen";

  @override
  State<StatefulWidget> createState() => ServerScreenState();
}

class ServerScreenState extends State<ServerScreen> {
  Person person;
  DocumentLevel idDocumentLevel;

  @override
  Widget build(BuildContext context) {
    if (!_loaded()) {
      final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
      person = ModalRoute.of(context).settings.arguments as Person;
      db.getById(person.documentIdKey).then((document) => document as Document).then((documentLevel) {
        setState(() {
          idDocumentLevel = documentLevel.level;
        });
      });
      return Scaffold(body: Center(child: Text("Kontaktiere Server...")));
    }
    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
      child: Scaffold(
        body: StarWarsMenuFrame(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: person != null ? _getForPerson(person) : _getMissing(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  bool _loaded() {
    return person != null && idDocumentLevel != null;
  }

  Widget _getForPerson(Person person) {
    return Table(
      children: [
        TableRow(children: [Text("Vorname"), Text(person.firstName)]),
        TableRow(children: [Text("Nachname"), Text(person.lastName)]),
        TableRow(children: [Text("ID Dokument"), Text(idDocumentLevel.isValid() ? "gültig" : "Fälschung Stufe " + idDocumentLevel.level.toString())]),
        TableRow(children: [Text("Scanner"), Text(person.scannerLevel.level == 0 ? "nicht vorhanden" : "Stufe " + person.scannerLevel.level.toString())]),
      ], // TODO change password button
    );
  }

  Widget _getMissing() {
    return Text("Unknown Person");
  }
}
