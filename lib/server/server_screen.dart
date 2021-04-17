import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/person.dart';

class ServerScreen extends StatelessWidget {
  static const routeName = "/server_screen";

  @override
  Widget build(BuildContext context) {
    final Person person = ModalRoute.of(context).settings.arguments as Person;
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

  Widget _getForPerson(Person person) {
    return Table(
      children: [
        TableRow(children: [Text("Vorname"), Text(person.firstName)]),
        TableRow(children: [Text("Nachname"), Text(person.lastName)]),
      ], // TODO change password button
    );
  }

  Widget _getMissing() {
    return Text("Unknown Person");
  }
}
