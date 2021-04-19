import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starwars_live/documents/id_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/scanner/scanner_result_screen.dart';
import 'package:starwars_live/server/server_screen.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = "/menu_screen";

  MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

// TODO make scaling adapt to device
const SCALE_MENU = 2.1;
const SCALE_NAV = 1.8;

class _MenuScreenState extends State<MenuScreen> {
  String userName = "";

  @override
  Widget build(BuildContext context) {
    userName = ModalRoute.of(context)?.settings.arguments as String? ?? "";
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: Theme(
              data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: SCALE_MENU)),
              child: StarWarsMenuFrame(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 1.11,
                  padding: EdgeInsets.only(top: 16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    StarWarsMenuButton(
                      child: Text("ID"),
                      onPressed: () => Navigator.of(context).pushNamed(IdScreen.routeName),
                    ),
                    StarWarsMenuButton(
                      child: Text("Scanner"),
                      onPressed: () => Navigator.of(context).pushNamed(ScannerResultScreen.routeName),
                    ),
                    StarWarsMenuButton(
                      child: Text("Lizenzen"),
                      onPressed: null,
                    ),
                    StarWarsMenuButton(
                      child: Text(""),
                      onPressed: null,
                    ),
                    StarWarsMenuButton(
                      child: Text("Bank"),
                      onPressed: null,
                    ),
                    StarWarsMenuButton(
                      child: Text(""),
                      onPressed: null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Theme(
              data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: SCALE_NAV)),
              child: StarWarsMenuFrame(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: StarWarsMenuButton(
                        padding: EdgeInsets.all(16),
                        child: Text("Server"),
                        onPressed: () => Navigator.of(context).pushNamed(ServerScreen.routeName),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: StarWarsMenuButton(
                        padding: EdgeInsets.all(16),
                        child: Text("Logout"),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
