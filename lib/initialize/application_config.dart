import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/online_database.dart';
import 'package:starwars_live/data_access/temp_storage.dart';
import 'package:starwars_live/scanner/scanner_service.dart';

class Application extends InheritedWidget {
  Application({required Widget child}) : super(child: child) {
    GetIt.instance.registerLazySingleton<DataService>(() => DataServiceImpl());
    GetIt.instance.registerSingleton<ScannerService>(ScannerServiceImpl());
    GetIt.instance.registerSingleton<SyncService>(SyncService());
    GetIt.instance.registerSingleton<TempStorageService>(TempStorageService());
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
