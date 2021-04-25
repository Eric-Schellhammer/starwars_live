import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:starwars_live/data_access/data_service.dart';

class SyncService {
  String? authority;
  String? dbInstance;

  void setUrl(String authority, String dbInstance) {
    this.authority = authority;
    this.dbInstance = dbInstance;
  }

  Future<void> fetchDatabase() async {
    return _requiresUpdate().then((updateRequired) => updateRequired ? _getUpdate().then((update) => _executeUpdate(update)) : null);
  }

  Future<bool> _requiresUpdate() {
    // TODO query endpoint
    return Future.value(true);
  }

  Future<String> _getUpdate() {
    return _getFixUpdate();
  }

  Future<String> _getRealUpdate() {
    // TODO complete URI
    // TODO use this method
    return http.get(Uri.https(authority!, "")).then((response) {
      if (response.statusCode == 200) return response.body;
      throw Exception("Fehler beim Kontaktieren des Servers: " + response.statusCode.toString());
    });
  }

  Future<String> _getFixUpdate() {
    return Future.value(""); // TODO return resource file or simply remove method
  }

  Future<void> _executeUpdate(String jsonString) {
    final dynamic json = jsonDecode(jsonString);

    return Future.value(); // TODO implement
  }
}
