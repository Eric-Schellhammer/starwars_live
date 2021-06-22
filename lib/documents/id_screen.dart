import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/moor_database.dart';
import 'package:starwars_live/documents/document_screen.dart';
import 'package:starwars_live/ui_services/user_service.dart';

class IdScreen extends StatefulWidget {
  static const String routeName = "/id_screen";

  @override
  State<StatefulWidget> createState() => IdScreenState();
}

class IdScreenState extends State<IdScreen> {
  final Future<Document> documentFuture = GetIt.instance
      .get<UserService>()
      .getLoggedInPerson()
      .then((person) => GetIt.instance.get<DataService>().getDocumentByKey(person.documentIdKey))
      .then((document) => document as Document);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Document>(
          future: documentFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return DocumentScreen(document: snapshot.data!);
            } else if (snapshot.hasError) {
              return Text("Fehler beim Laden des Dokuments: " + snapshot.error.toString());
            }
            return Text("Kontaktiere Server...");
          },
        ),
      ),
    );
  }
}
