import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';

class Application extends InheritedWidget {
  Application({@required Widget child}) : super(child: child) {
    GetIt.instance.registerLazySingleton<DataService>(() => DataServiceImpl());
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}
