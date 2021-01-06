import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starwars_live/scanner/scanner_result_screen.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = "/menu_screen";

  MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String userName = "";

  @override
  Widget build(BuildContext context) {
    userName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(userName + ": Apps Menü"),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          RaisedButton(
            child: Text("Meine Dokumente"),
            onPressed: null,
          ),
          RaisedButton(
            child: Text("Scanner"),
            onPressed: () {
              Navigator.of(context).pushNamed(ScannerResultScreen.routeName);
            },
          )
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.logout),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
