import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/documents/document_screen.dart';
import 'package:starwars_live/model/document.dart';

class IdScreen extends StatefulWidget {
  static const String routeName = "/id_screen";

  @override
  State<StatefulWidget> createState() => IdScreenState();
}

class IdScreenState extends State<IdScreen> {
  late Future<Document> futureDocument;

  @override
  void initState() {
    super.initState();
    var dataService = GetIt.instance.get<DataService>();
    final StarWarsDb db = dataService.getDb();
    futureDocument = dataService.getLoggedInPerson().then((person) => db.getById(person.documentIdKey)).then((document) => document as Document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Document>(
          future: futureDocument,
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
