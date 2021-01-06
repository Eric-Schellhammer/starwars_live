import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/local_database.dart';
import 'package:starwars_live/model/person.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login_screen";

  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int _counter = 0;
  List<Person> persons = List();

  void _incrementCounter() async {
    _counter++;
    Person person = new Person(
        id: _counter,
        firstName: 'Person' + _counter.toString(),
        lastName: 'Dalton');
    final StarWarsDb starWarsDb = GetIt.instance.get<DataService>().getDb();
    await starWarsDb.createPerson(person);
    await starWarsDb.getAllPersons().then((value) => setState(() {
          persons = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Imperial ID Scanner"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: persons.isEmpty
                ? [Text("no one")]
                : persons
                    .map((person) =>
                        Text(person.firstName + " " + person.lastName))
                    .toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
