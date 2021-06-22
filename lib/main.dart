// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starwars_live/banking/banking_screen.dart';
import 'package:starwars_live/documents/documents_list_screen.dart';
import 'package:starwars_live/documents/id_screen.dart';
import 'package:starwars_live/initialize/application_config.dart';
import 'package:starwars_live/main_screens/login_screen.dart';
import 'package:starwars_live/main_screens/menu_screen.dart';
import 'package:starwars_live/main_screens/mode_screen.dart';
import 'package:starwars_live/main_screens/server_screen.dart';
import 'package:starwars_live/medscan/medscan_screen.dart';
import 'package:starwars_live/scanner/scanner_result_screen.dart';
import 'package:starwars_live/scanner/scanner_screen.dart';

void main() {
  final Application application = Application(child: StarWarsLive());
  runApp(application);
}

class StarWarsLive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars Live',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        canvasColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme).apply(bodyColor: MAIN_COLOR),
      ),
      home: ModeScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        MenuScreen.routeName: (ctx) => MenuScreen(),
        IdScreen.routeName: (ctx) => IdScreen(),
        DocumentsListScreen.routeName: (ctx) => DocumentsListScreen(),
        BankingScreen.routeName: (ctx) => BankingScreen(),
        IdScanScreen.routeName: (ctx) => IdScanScreen(),
        ScannerResultScreen.routeName: (ctx) => ScannerResultScreen(),
        MedScanScreen.routeName: (ctx) => MedScanScreen(),
        ServerScreen.routeName: (ctx) => ServerScreen(),
      },
    );
  }
}

const Color MAIN_COLOR = Colors.lightBlueAccent;
const Color MAIN_COLOR_INACTIVE = Colors.blueGrey;
