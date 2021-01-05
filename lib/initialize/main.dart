import 'package:flutter/material.dart';
import 'package:starwars_live/initialize/application_config.dart';

import 'login_screen.dart';

void main() {
  final Application application = Application(child: StarWarsLive());
  runApp(application);
}

class StarWarsLive extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
      routes: {
        //ItemListScreen.routeName: (ctx) => ItemListScreen(),
      },
    );
  }
}
