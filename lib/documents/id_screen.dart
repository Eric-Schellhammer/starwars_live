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
  Document? document;

  @override
  Widget build(BuildContext context) {
    if (document != null) return DocumentScreen(document: document!);

    SharedPreferences.getInstance().then((preferences) {
      final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT));
      final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
      db.getById(accountKey).then((account) => db.getById((account as Account).personKey).then((person) => db.getById((person as Person).documentIdKey).then((document) {
            setState(() => this.document = document as Document); // TODO handle unknown account, person, document
          })));
    });
    return Scaffold(body: Center(child: Text("Kontaktiere Server...")));
  }
}
