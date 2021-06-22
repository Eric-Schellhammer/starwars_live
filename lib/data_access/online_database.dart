import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:starwars_live/data_access/data_service.dart';

class SyncService {
  String? host;
  String? dbInstance;

  void setUrl(String host, String dbInstance) {
    this.host = host;
    this.dbInstance = dbInstance;
  }

  Future<bool> loadIfAvailable() {
    return fetchDatabase().then((value) => true);
  }

  Future<void> fetchDatabase() async {
    return _requiresUpdate().then((updateRequired) => updateRequired ? _getUpdate().then((update) => _executeUpdate(update)) : null);
  }

  Future<bool> _requiresUpdate() {
    // TODO query endpoint for update
    return Future.value(true);
  }

  Future<String> _getUpdate() {
    return host == null || dbInstance == null ? Future.value("") : http.read(Uri.http(host!, "SWL-" + dbInstance! + ".txt"));
  }

  Future<void> _executeUpdate(String jsonString) {
    return GetIt.instance.get<DataService>().setImport(jsonString);
  }
}
