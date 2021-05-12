import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_live/banking/receive_flow.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/account.dart';
import 'package:starwars_live/model/person.dart';

class BankingScreen extends StatefulWidget {
  static const String routeName = "/banking_screen";

  @override
  State<StatefulWidget> createState() => BankingScreenState();
}

class BankingScreenState extends State<BankingScreen> {
  int? credits;
  String? accountCode;

  @override
  Widget build(BuildContext context) {
    if (!_loaded()) {
      SharedPreferences.getInstance().then((preferences) {
        final AccountKey accountKey = AccountKey(preferences.getInt(LOGGED_IN_ACCOUNT)!); // TODO handle missing account
        final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
        db.getById(accountKey).then((account) => db.getById((account as Account).personKey).then((person) {
              setState(() {
                this.credits = (person as Person).credits;
                this.accountCode = person.key.intKey.toString();
              });
            }));
      });
      return Scaffold(body: Center(child: Text("Kontaktiere Server...")));
    }

    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
      child: Scaffold(
        body: StarWarsSwipeToDismissScreen(
          child: _getEntriesList(),
        ),
      ),
    );
  }

  bool _loaded() {
    return credits != null;
  }

  Widget _getEntriesList() {
    return ListView(
      children: [
        _buildBalanceTile(),
        _buildSendTile(),
        _buildReceiveTile(),
      ],
    );
  }

  Widget _buildBalanceTile() {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Kontostand:"),
            Text(credits.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSendTile() {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Text("Sende Credits"),
        onTap: null,
      ),
    );
  }

  Widget _buildReceiveTile() {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Text("Empfange Credits"),
        onTap: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => BankingReceiveId(accountCode: accountCode!))),
      ),
    );
  }
}
