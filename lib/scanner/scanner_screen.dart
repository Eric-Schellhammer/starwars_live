import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/scanner/scanner_result_screen.dart';
import 'package:starwars_live/ui_services/scanner_service.dart';

class IdScanScreen extends ScannerScreen {
  static const routeName = "/id_scan_screen";

  IdScanScreen({Key? key})
      : super(
          handleScannedCode: (code) => GetIt.instance.get<ScannerService>().resolveScannedDocumentCode(code),
          handleSuccessfulScan: (context, result) => Navigator.of(context).pushReplacementNamed(ScannerResultScreen.routeName, arguments: result),
          onCancel: (context) => Navigator.of(context).pushReplacementNamed(ScannerResultScreen.routeName),
          scanPrompt: "Führe Scan durch",
        );
}

class ScannerScreen extends StatefulWidget {
  final Future<ScanResult> Function(String) handleScannedCode;
  final void Function(BuildContext, ScanSuccess) handleSuccessfulScan;
  final void Function(BuildContext) onCancel;
  final String scanPrompt;
  final String? testResult;

  const ScannerScreen({
    Key? key,
    required this.handleScannedCode,
    required this.handleSuccessfulScan,
    required this.onCancel,
    this.scanPrompt = "Führe Scan durch",
    this.testResult,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String errorMessage = "";

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StarWarsMasterDetailScreen(
      masterChild: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
      detailChildren: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDetailChildren(),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      final Barcode? scannedCode = scanData;
      if (scannedCode != null) {
        final String format = describeEnum(scannedCode.format);
        if (format == "qrcode") {
          widget.handleScannedCode(scannedCode.code).then((result) => _displayResult(result));
        }
      }
    });
  }

  void _displayResult(ScanResult result) {
    if (result.scannedCodeWasRecognized) {
      controller?.pauseCamera();
      controller?.dispose();
      widget.handleSuccessfulScan(context, result as ScanSuccess);
    } else {
      setState(() {
        errorMessage = result is ScanFailure ? result.errorMessage : "Unbekannter Fehler";
      });
    }
  }

  List<Widget> _buildDetailChildren() {
    final List<Widget> detailChildren = List.empty(growable: true);
    if (errorMessage.isNotEmpty) {
      detailChildren.add(Text(
        errorMessage,
        style: TextStyle(color: Colors.red, fontSize: 20),
      ));
    } else {
      detailChildren.add(Text(
        widget.scanPrompt,
        style: TextStyle(fontSize: 20),
      ));
    }
    detailChildren.add(StarWarsButton(
      child: Text("Abbrechen"),
      onPressed: () => widget.onCancel(context),
    ));
    if (widget.testResult != null) {
      detailChildren.add(StarWarsButton(
        child: Text("Fake Scan"),
        onPressed: () => widget.handleScannedCode(widget.testResult!).then((result) => _displayResult(result)),
      ));
    }
    return detailChildren;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
