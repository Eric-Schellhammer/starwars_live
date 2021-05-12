import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/banking/banking_screen.dart';
import 'package:starwars_live/documents/documents_list_screen.dart';
import 'package:starwars_live/documents/id_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/scanner/scanner_screen.dart';
import 'package:starwars_live/scanner/scanner_service.dart';
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
    return StarWarsMasterDetailScreen(
      masterTextFactor: 3.0,
      masterChild: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.11,
        padding: EdgeInsets.only(top: 16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          StarWarsMenuButton(
            child: FittedBox(child: Text("ID")),
            onPressed: () => Navigator.of(context).pushNamed(IdScreen.routeName),
          ),
          StarWarsMenuButton(
            child: FittedBox(child: Text("Scanner")),
            onPressed: GetIt.instance.get<ScannerService>().isScannerPresent() ? () => Navigator.of(context).pushNamed(ScanScreen.routeName) : null,
          ),
          StarWarsMenuButton(
            child: FittedBox(child: Text("Lizenzen")),
            onPressed: () => Navigator.of(context).pushNamed(DocumentsListScreen.routeName),
          ),
          StarWarsMenuButton(
            child: FittedBox(child: Text("Med Scan")),
            onPressed: null,
          ),
          StarWarsMenuButton(
            child: FittedBox(child: Text("Bank")),
            onPressed: () => Navigator.of(context).pushNamed(BankingScreen.routeName),
          ),
          StarWarsMenuButton(
            child: Text(""),
            onPressed: null,
          ),
        ],
      ),
      detailTextFactor: 2.0,
      detailChildren: [
        StarWarsTextButton(
          text: "Server",
          onPressed: () => Navigator.of(context).pushNamed(ServerScreen.routeName),
        ),
        StarWarsTextButton(
          text: "Logout",
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
