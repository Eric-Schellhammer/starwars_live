import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/initialize/login_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';

enum Modes { LIVE, COPY, LOCAL }

class ModeScreen extends StatefulWidget {
  ModeScreen({Key? key}) : super(key: key);

  @override
  _ModeScreenState createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  Modes currentMode = Modes.LOCAL;
  String serverIpAddress = "";
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
          children: _getChildren(),
        ),
      ),
    );
  }

  List<Widget> _getChildren() {
    final List<Widget> children = [
      Text(
        "Server-Zugriff:",
        style: TextStyle(fontSize: 25),
      )
    ];
    children.add(DropdownButton<Modes>(
        value: currentMode,
        items: Modes.values
            .map((mode) => DropdownMenuItem<Modes>(
                  value: mode,
                  child: Text(_modeName(mode)),
                ))
            .toList(),
        onChanged: (Modes? newMode) {
          setState(() {
            errorMessage = "";
            currentMode = newMode ?? Modes.LOCAL;
          });
        }));
    if (currentMode != Modes.LOCAL) {
      children.add(Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text(
          "IP-Adresse des Servers:",
          style: TextStyle(fontSize: 20),
        ),
      ));
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(flex: 1, child: Text("")),
          Flexible(
              flex: 2,
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    serverIpAddress = value;
                    errorMessage = "";
                  });
                },
              )),
          Flexible(flex: 1, child: Text("")),
        ],
      ));
    }
    if (errorMessage.isNotEmpty)
      children.add(Text(
        errorMessage,
        style: TextStyle(color: Colors.red),
      ));
    children.add(StarWarsButton(
      child: Text("OK"),
      onPressed: () {
        if (currentMode == Modes.LOCAL) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          if (GetIt.instance.get<DataService>().isAvailable(serverIpAddress)) {
            // currently, all values are rejected
          } else {
            setState(() {
              errorMessage = "Server nicht erreichbar";
            });
          }
        }
      },
    ));
    return children;
  }

  String _modeName(Modes mode) {
    switch (mode) {
      case Modes.LIVE:
        return "jederzeit";
      case Modes.COPY:
        return "nur beim Synchronisieren";
      case Modes.LOCAL:
        return "ohne Server (Debug-Feature)";
      default:
        return "<unknown>";
    }
  }
}
