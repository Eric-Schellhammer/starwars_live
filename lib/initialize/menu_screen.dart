import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/main.dart';
import 'package:starwars_live/scanner/scanner_result_screen.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = "/menu_screen";

  MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

const SCALE_MENU = 2.2;
const SCALE_NAV = 1.8;

class _MenuScreenState extends State<MenuScreen> {
  String userName = "";

  @override
  Widget build(BuildContext context) {
    userName = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: StarWarsMenuFrame(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.11,
                padding: EdgeInsets.only(top: 16),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  StarWarsMenuButton(
                    child: Text(
                      "ID",
                      textScaleFactor: SCALE_MENU,
                    ),
                    onPressed: null,
                  ),
                  StarWarsMenuButton(
                    child: Text(
                      "Scanner",
                      textScaleFactor: SCALE_MENU,
                    ),
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(ScannerResultScreen.routeName);
                    },
                  ),
                  StarWarsMenuButton(
                    child: Text(
                      "Lizenzen",
                      textScaleFactor: SCALE_MENU,
                    ),
                    onPressed: null,
                  ),
                  StarWarsMenuButton(
                    child: Text(
                      "",
                      textScaleFactor: SCALE_MENU,
                    ),
                    onPressed: null,
                  ),
                  StarWarsMenuButton(
                    child: Text(
                      "Bank",
                      textScaleFactor: SCALE_MENU,
                    ),
                    onPressed: null,
                  ),
                  StarWarsMenuButton(
                    child: Text(
                      "",
                      textScaleFactor: SCALE_MENU,
                    ),
                    onPressed: null,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: StarWarsMenuFrame(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: StarWarsMenuButton(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "Server",
                        textScaleFactor: SCALE_NAV,
                      ),
                      onPressed: null,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: StarWarsMenuButton(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          "Logout",
                          textScaleFactor: SCALE_NAV,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
