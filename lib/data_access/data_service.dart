import 'package:starwars_live/data_access/local_database.dart';

class DataService {

  StarWarsDb starWarsDb;

  DataService() {
    starWarsDb = StarWarsDb();
  }

  StarWarsDb getDb() {
    return starWarsDb;
  }
}