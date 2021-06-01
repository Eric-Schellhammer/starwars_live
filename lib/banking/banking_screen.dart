import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:starwars_live/banking/receive_flow.dart';
import 'package:starwars_live/banking/send_flow.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/data_access/temp_storage.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/main.dart';
import 'package:starwars_live/model/banking.dart';

class BankingScreen extends StatefulWidget {
  static const String routeName = "/banking_screen";

  @override
  State<StatefulWidget> createState() => BankingScreenState();
}

class BankingScreenState extends State<BankingScreen> {
  late Future<int> creditsFuture;

  @override
  void initState() {
    super.initState();
    var dataService = GetIt.instance.get<DataService>();
    creditsFuture = dataService.getLoggedInPerson().then((person) => dataService.getCredits(person.key));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 2.0)),
      child: Scaffold(
        body: StarWarsSwipeToDismissScreen(
          child: FutureBuilder<int>(
            future: creditsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData)
                return _getEntriesList(snapshot.data!);
              else
                return Text("Kontaktiere server...");
            },
          ),
        ),
      ),
    );
  }

  Widget _getEntriesList(int credits) {
    final List<Widget> children = [
      _buildBalanceTile(credits),
      _buildSendTile(credits),
      _buildReceiveTile(),
    ];
    final CreditTransfer? lastSendTransfer = GetIt.instance.get<TempStorageService>().lastSendTransfer;
    if (lastSendTransfer != null) children.add(_buildLastTransferTile(lastSendTransfer));
    return ListView(
      children: children,
    );
  }

  Widget _buildBalanceTile(int credits) {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Kontostand:"),
            Text(new BankBalance(credits).toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSendTile(int credits) {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Text(
          "Sende Credits",
          style: credits > 0 ? null : TextStyle(color: MAIN_COLOR_INACTIVE),
        ),
        onTap: credits > 0
            ? () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => BankingSendScreen1_ScanReceiver(maxAmount: credits)),
                )
            : null,
      ),
    );
  }

  Widget _buildReceiveTile() {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Text("Empfange Credits"),
        onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankingReceiveScreen1_ShowReceiveId()),
        ),
      ),
    );
  }

  Widget _buildLastTransferTile(CreditTransfer lastSendTransfer) {
    return StarWarsMenuFrame(
      child: ListTile(
        title: Text("Letzten Sende-Transfer nochmal anzeigen"),
        onTap: () => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BankingSendScreen3_ShowTransfer(creditTransfer: lastSendTransfer)),
        ),
      ),
    );
  }
}
