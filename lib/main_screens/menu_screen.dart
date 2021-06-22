import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/banking/banking_screen.dart';
import 'package:starwars_live/documents/documents_list_screen.dart';
import 'package:starwars_live/documents/id_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/medscan/medscan_screen.dart';
import 'package:starwars_live/scanner/scanner_screen.dart';
import 'package:starwars_live/ui_services/user_service.dart';
import 'package:starwars_live/main_screens/server_screen.dart';

class MenuScreen extends StatefulWidget {
  static const routeName = "/menu_screen";

  MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String userName = "";

  @override
  Widget build(BuildContext context) {
    userName = ModalRoute.of(context)?.settings.arguments as String? ?? "";
    final scannerService = GetIt.instance.get<UserService>();
    final bool docScanner = scannerService.isScannerPresent();
    final bool medScanner = scannerService.hasMedScanner();
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
            onPressed: docScanner ? () => Navigator.of(context).pushNamed(IdScanScreen.routeName) : null,
          ),
          StarWarsMenuButton(
            child: FittedBox(child: Text("Lizenzen")),
            onPressed: () => Navigator.of(context).pushNamed(DocumentsListScreen.routeName),
          ),
          StarWarsMenuButton(
            child: FittedBox(child: Text("Med Scan")),
            onPressed: medScanner ? () => Navigator.of(context).pushNamed(MedScanScreen.routeName) : null,
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
