import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/initialize/menu_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login_screen";

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String userName = "";
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
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
            Text("-- noch nicht implementiert --"),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: RaisedButton(
                  onPressed: userName.isEmpty ? null : () => _checkLogin(),
                  child: Text(
                    "Login",
                  )),
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
    GetIt.instance
        .get<DataService>()
        .validateAccount(userName, "")
        .then((accepted) {
      if (accepted) {
        Navigator.of(context)
            .pushNamed(MenuScreen.routeName, arguments: userName);
      } else {
        setState(() {
          errorMessage = "Login fehlgeschlagen";
        });
      }
    });
  }
}
