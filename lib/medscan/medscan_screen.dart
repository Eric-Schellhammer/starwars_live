import 'package:flutter/material.dart';
import 'package:starwars_live/initialize/starwars_widgets.dart';
import 'package:starwars_live/main.dart';

class MedScanScreen extends StatefulWidget {
  static const routeName = "/medscan_screen";

  @override
  State<StatefulWidget> createState() => MedScanScreenState();
}

class MedScanScreenState extends State<MedScanScreen> {
  MedScanResult? scanResult;
  bool scanning = true;

  @override
  Widget build(BuildContext context) {
    return DoubleTextSizeTheme(
      child: StarWarsMasterDetailScreen(
        masterChild: scanResult == null ? _prepareScan() : (scanning ? _performScan() : _finishScan()),
        detailChildren: [
          StarWarsTextButton(
            text: (scanResult == null || scanning) ? "Abbrechen" : "Schließen",
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  Widget _prepareScan() {
    return GestureDetector(
      child: _human(),
      onHorizontalDragEnd: (details) => _setResult(context, MedScanResult.WARN),
      onVerticalDragUpdate: (details) => details.delta.direction > 0 ? _setResult(context, MedScanResult.CRITICAL) : _setResult(context, MedScanResult.OK),
    );
  }

  Widget _performScan() {
    return Stack(
      children: [
        Center(child: ScannerWidget(() => setState(() => scanning = false))),
        Center(child: _human()),
      ],
    );
  }

  Widget _finishScan() {
    return Center(child: _human(color: _getColor()));
  }

  void _setResult(BuildContext context, MedScanResult scanResult) {
    setState(() => this.scanResult = scanResult);
  }

  Widget _human({Color color = MAIN_COLOR}) {
    return Center(
      child: Image.asset(
        "assets/HumanOutline.png",
        color: color,
        fit: BoxFit.fill,
      ),
    );
  }

  Color _getColor() {
    if (scanResult == null) return MAIN_COLOR;
    switch (scanResult) {
      case MedScanResult.OK:
        return Colors.green;
      case MedScanResult.WARN:
        return Colors.amber;
      case MedScanResult.CRITICAL:
      default:
        return Colors.red;
    }
  }
}

enum MedScanResult { OK, WARN, CRITICAL }

class ScannerWidget extends StatefulWidget {
  final Function() finishHook;

  ScannerWidget(this.finishHook);

  @override
  State<StatefulWidget> createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0.0, -10),
    end: const Offset(0.0, 10),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linearToEaseOut,
  ));

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        widget.finishHook.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(child: SizedBox(height: 10.0, width: 150), color: MAIN_COLOR),
      ),
    );
  }
}
