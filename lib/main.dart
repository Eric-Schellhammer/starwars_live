import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starwars_live/initialize/application_config.dart';
import 'package:starwars_live/initialize/login_screen.dart';
import 'package:starwars_live/initialize/menu_screen.dart';
import 'package:starwars_live/initialize/mode_screen.dart';
import 'package:starwars_live/scanner/scan_screen.dart';
import 'package:starwars_live/scanner/scanner_result_screen.dart';

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
        textTheme:
            GoogleFonts.titilliumWebTextTheme(Theme.of(context).textTheme)
                .apply(bodyColor: MAIN_COLOR),
      ),
      home: ModeScreen(),
      routes: {
        LoginScreen.routeName: (ctx) => LoginScreen(),
        MenuScreen.routeName: (ctx) => MenuScreen(),
        ScanScreen.routeName: (ctx) => ScanScreen(),
        ScannerResultScreen.routeName: (ctx) => ScannerResultScreen(),
      },
    );
  }
}

const Color MAIN_COLOR = Colors.lightBlueAccent;
const Color MAIN_COLOR_INACTIVE = Colors.blueGrey;