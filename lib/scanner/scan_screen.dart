import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:starwars_live/data_access/data_service.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/scanner/scanner_result_screen.dart';

class ScanScreen extends StatefulWidget {
  static const routeName = "/scan_screen";

  ScanScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode result;
  QRViewController controller;
  String errorMessage = "";

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            // To ensure the Scanner view is properly sizes after rotation
            // we need to listen for Flutter SizeChanged notification and update controller
            child: StarWarsMenuFrame(
              child: NotificationListener<SizeChangedLayoutNotification>(
                onNotification: (notification) {
                  Future.microtask(() => controller?.updateDimensions(qrKey));
                  return false;
                },
                child: SizeChangedLayoutNotifier(
                  key: const Key('qr-size-notifier'),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: StarWarsMenuFrame(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (result != null)
                        ? Text(
                            errorMessage,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          )
                        : Text(
                            'Führe Scan durch',
                            style: TextStyle(fontSize: 20),
                          ),
                    StarWarsButton(
                        child: Text("Abbrechen"),
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed(
                              ScannerResultScreen.routeName);
                        })
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        final String format = describeEnum(result.format);
        if (format == "qrcode") {
          _resolveScan(result.code);
        }
      });
    });
  }

  void _resolveScan(String qrText) {
    final ScanResult result = GetIt.instance.get<DataService>().scan(qrText);
    if (result.idWasRecognized) {
      controller?.pauseCamera();
      controller?.dispose();
      Navigator.pushReplacementNamed(context, ScannerResultScreen.routeName,
          arguments: result);
    } else {
      setState(() {
        errorMessage = "Unbekannte Signatur";
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
