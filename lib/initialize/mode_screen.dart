import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info/package_info.dart';
import 'package:starwars_live/data_access/online_database.dart';
import 'package:starwars_live/initialize/login_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/model/document.dart';

enum Modes { LIVE, COPY }

class ModeScreen extends StatefulWidget {
  ModeScreen({Key? key}) : super(key: key);

  @override
  _ModeScreenState createState() => _ModeScreenState();
}

class _ModeScreenState extends State<ModeScreen> {
  Modes currentMode = Modes.COPY;
  final TextEditingController serverIpAddressController = TextEditingController();
  String errorMessage = "";
  String errorDescription = "";
  String? version;
  bool waiting = false;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((packageInfo) => setState(() => this.version = packageInfo.version));
    DocumentType.ensureLoaded();
    serverIpAddressController.text = "devilturm.synology.me";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Star Wars Live"),
      ),
      body: waiting && errorMessage.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _getChildren(),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Text("Version " + (version ?? ""))],
                ),
              ],
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
            errorDescription = "";
            waiting = false;
            currentMode = newMode ?? Modes.COPY;
          });
        }));
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
              controller: serverIpAddressController,
              onChanged: (value) {
                setState(() {
                  errorMessage = "";
                  errorDescription = "";
                  waiting = false;
                });
              },
            )),
        Flexible(flex: 1, child: Text("")),
      ],
    ));
    if (errorMessage.isNotEmpty) {
      children.add(Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 20),
      ));
      children.add(Text(
        errorDescription,
        style: TextStyle(color: Colors.indigo),
      ));
    }
    children.add(StarWarsButton(
      child: Text("OK"),
      onPressed: waiting
          ? null
          : () async {
              setState(() => waiting = true);
              final syncService = GetIt.instance.get<SyncService>();
              syncService.setUrl(serverIpAddressController.text, "DB1");
              final String error = await syncService.loadIfAvailable().then((success) => "").onError((error, stackTrace) => error.toString());
              if (error.isEmpty) {
                setState(() => waiting = false);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              } else {
                setState(() {
                  errorMessage = "Server nicht erreichbar";
                  errorDescription = "(" + error + ")";
                });
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
      default:
        return "<unknown>";
    }
  }
}
