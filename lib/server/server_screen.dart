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
  List<Document>? documents;
  late Future<DocumentLevel> futureIdDocumentLevel;

  @override
  void initState() {
    super.initState();
    futureIdDocumentLevel = SharedPreferences.getInstance().then((preferences) async {
      final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT));
      final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
      return db.getById(accountKey).then((account) => db.getById((account as Account).personKey).then((person) {
            this.person = person as Person;
            return db.getWhere(DocumentKey.dbTableKey, (conditions) => conditions.whereEquals(Document.COL_OWNER, person.key.intKey)).then((documents) {
              this.documents = documents.where((document) => document.type != DocumentType.PERSONAL_ID).toList(growable: false);
              return documents.where((document) => document.type == DocumentType.PERSONAL_ID).first.level;
            });
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
        child: Scaffold(
          body: StarWarsSwipeToDismissScreen(
            child: FutureBuilder<DocumentLevel>(
                future: futureIdDocumentLevel,
                builder: (context, snapshot) {
                  final valid = snapshot.hasData && snapshot.data != null && person != null;
                  if (valid)
                    return _getForPerson(person!, snapshot.data!);
                  else if (snapshot.hasError) return _getMissing();
                  return Text("Kontaktiere Server...");
                }),
          ),
        ));
  }

  Widget _getForPerson(Person person, DocumentLevel idDocumentLevel) {
    int scannerLevel = person.scannerLevel?.level ?? 0;
    final List<TableRow> children = [
      TableRow(children: [Text("Vorname"), Text(person.firstName)]),
      TableRow(children: [Text("Nachname"), Text(person.lastName)]),
      TableRow(children: [Text("ID Dokument"), _getValidity(idDocumentLevel)]),
      TableRow(children: [Text("Scanner"), Text(scannerLevel == 0 ? "N/A" : "Stufe " + scannerLevel.toString())]),
    ].toList();
    documents!.forEach((document) {
      children.add(
        TableRow(children: [FittedBox(child: Text(document.type.name)), _getValidity(document.level)]),
      );
    });
    return Center(
      child: Table(
        children: children, // TODO change password button
      ),
    );
  }

  Widget _getValidity(DocumentLevel level) {
    return FittedBox(child: Text(level.isValid() ? "gültig" : "Fälschung Stufe " + level.level.toString()));
  }

  Widget _getMissing() {
    return Text("Unknown Person");
  }
}
