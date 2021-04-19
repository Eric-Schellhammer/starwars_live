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

class IdScreen extends StatefulWidget {
  static const String routeName = "/id_screen";

  @override
  State<StatefulWidget> createState() => IdScreenState();
}

class IdScreenState extends State<IdScreen> {
  String? code;

  @override
  Widget build(BuildContext context) {
    if (!_loaded()) {
      SharedPreferences.getInstance().then((preferences) {
        final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT));
        final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
        db.getById(accountKey).then((account) => db.getById((account as Account).personKey).then((person) => db.getById((person as Person).documentIdKey).then((document) {
              setState(() => code = (document as Document).getKey().intKey.toString());
            })));
      });
      return Scaffold(body: Center(child: Text("Kontaktiere Server...")));
    }

    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
      child: Scaffold(
        body: StarWarsMenuFrame(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: _getIdCode(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text("OK"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  bool _loaded() {
    return code != null;
  }

  Widget _getIdCode() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Personal ID:"),
          QrImage(
            backgroundColor: Colors.white,
            data: code ?? "",
            version: QrVersions.auto,
            size: 200.0,
          ),
        ],
      ),
    );
  }
}
