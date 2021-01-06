import 'package:flutter/material.dart';
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
        visualDensity: VisualDensity.adaptivePlatformDensity,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.blueGrey,
          textTheme: ButtonTextTheme.primary,
        ),
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
