import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/documents/document_screen.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/document.dart';
import 'package:starwars_live/model/person.dart';

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
    futureDocument = SharedPreferences.getInstance().then((preferences) {
      final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT));
      final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
      return db
          .getById(accountKey)
          .then((account) => db.getById((account as Account).personKey))
          .then((person) => db.getById((person as Person).documentIdKey))
          .then((document) => document as Document);
    });
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
              return Text("Fehler beim Laden des Dokuments.");
            }
            return Text("Kontaktiere Server...");
          },
        ),
      ),
    );
  }
}
