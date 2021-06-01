import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/data_access/temp_storage.dart';
import 'package:starwars_live/initialize/menu_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/main.dart';
import 'package:starwars_live/model/person.dart';
import 'package:starwars_live/scanner/scanner_service.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login_screen";

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = "";
  String password = "";
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    GetIt.instance.get<TempStorageService>().lastSendTransfer = null;
    return Scaffold(
      appBar: AppBar(
        title: Text("Star Wars Live"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Name",
              style: TextStyle(fontSize: 20),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(flex: 1, child: Text("")),
              Flexible(
                  flex: 2,
                  child: TextField(
                    cursorColor: MAIN_COLOR,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MAIN_COLOR_INACTIVE)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MAIN_COLOR)),
                    ),
                    autofocus: true,
                    onChanged: (value) {
                      setState(() {
                        errorMessage = "";
                        userName = value;
                      });
                    },
                  )),
              Flexible(flex: 1, child: Text(""))
            ]),
            Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text(
                  "Passwort",
                  style: TextStyle(fontSize: 20),
                )),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Flexible(flex: 1, child: Text("")),
              Flexible(
                  flex: 2,
                  child: TextField(
                    cursorColor: MAIN_COLOR,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: MAIN_COLOR_INACTIVE)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: MAIN_COLOR)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        errorMessage = "";
                        password = value;
                      });
                    },
                  )),
              Flexible(flex: 1, child: Text(""))
            ]),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: StarWarsButton(
                onPressed: userName.isEmpty ? null : () => _checkLogin(),
                child: Text("Login"),
              ),
            ),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  void _checkLogin() {
    GetIt.instance.get<DataService>().validateAccount(userName, password).then((account) {
      if (account != null) {
        SharedPreferences.getInstance().then((preferences) => preferences.setInt(LOGGED_IN_ACCOUNT, account.getKey().intKey));
        final StarWarsDb db = GetIt.instance.get<DataService>().getDb();
        db.getById(account.personKey).then((person) {
          final Person p = person as Person;
          GetIt.instance.get<ScannerService>().setScanner(p.scannerLevel, p.hasMedScanner);
        }).then((__) => Navigator.of(context).pushNamed(MenuScreen.routeName, arguments: userName));
      } else {
        setState(() {
          errorMessage = "Login fehlgeschlagen";
        });
      }
    });
  }
}
