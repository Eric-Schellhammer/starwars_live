// @dart=2.9
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/initialize/application_config.dart';

void main() {
  final Application application = Application(child: StarWarsLiveServer());
  runApp(application);
}

class StarWarsLiveServer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars Live Server',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        canvasColor: Colors.black,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ServerScreen(),
    );
  }
}

class ServerScreen extends StatelessWidget {
  final Future<HttpServer> server = _startServer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: server,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Text("Starting Server");
          else
            return Text("Server running.");
        },
      ),
    );
  }

  static Future<HttpServer> _startServer() {
    var handler = const Pipeline().addMiddleware(logRequests()).addHandler(_handleDbRequest);
    return shelf_io.serve(handler, 'localhost', 8080).then((server) {
      // Enable content compression
      server.autoCompress = true;
      print('Serving StarWarsDB at http://${server.address.host}:${server.port}');
      return server;
    });
  }
}

Future<Response> _handleDbRequest(Request request) async {
  var segments = request.url.pathSegments;
  var call = request.method + ":" + (segments.isNotEmpty ? segments.last : "");
  switch (call) {
    case "GET:all":
      return _handleGetAll();
    case "POST:sync":
      return request.readAsString().then((body) => _handleSync(body));
    default:
      return Response.notFound("Unknown request");
  }
}

Future<Response> _handleGetAll() {
  return GetIt.instance.get<DataService>().getExport().then((dbSerialized) => Response.ok(dbSerialized));
}

Future<Response> _handleSync(String incoming) async {
  return Response.found("NYI");
}
