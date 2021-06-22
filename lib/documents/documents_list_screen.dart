import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/moor_database.dart';
import 'package:starwars_live/documents/document_screen.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/ui_services/user_service.dart';

class DocumentsListScreen extends StatefulWidget {
  static const String routeName = "/documents_list_screen";

  @override
  State<StatefulWidget> createState() => DocumentsListScreenState();
}

class DocumentsListScreenState extends State<DocumentsListScreen> {
  final Future<List<Document>> documentsFuture = GetIt.instance.get<DataService>().getDocumentsOfPerson(GetIt.instance.get<UserService>().getLoggedInPersonKey());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: documentsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Scaffold(body: Center(child: Text("Kontaktiere Server...")));
          else
            return Theme(
              data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
              child: Scaffold(
                body: StarWarsSwipeToDismissScreen(
                  child: _getDocumentsList(snapshot.data as List<Document>),
                ),
              ),
            );
        });
  }

  Widget _getDocumentsList(List<Document> docs) {
    if (docs.isEmpty) return Center(child: Text("Keine Dokumente vorhanden."));
    return ListView(
      children: docs.map((document) => _buildDocumentTile(document)).toList(),
    );
  }

  Widget _buildDocumentTile(Document document) {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Text(document.documentType.name.toString()),
        subtitle: document.information != null
            ? Text(
                document.information!,
                style: TextStyle(color: Colors.blue),
              )
            : null,
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => DocumentScreen(document: document))),
      ),
    );
  }
}
