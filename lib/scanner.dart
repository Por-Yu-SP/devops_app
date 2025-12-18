import "package:flutter/material.dart";
import 'package:mobile_scanner/mobile_scanner.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final MobileScannerController scancontrol = MobileScannerController();
  bool _handled = false;

  @override
  void dispose() {
    scancontrol.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text(
          "Scan your Id",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: MobileScanner(
        controller: scancontrol,
        onDetect:(capture) async{
          if(_handled) return;
          final code=capture.barcodes.firstOrNull?.rawValue;
          if(code == null || code.isEmpty) 
          {return;}
          _handled=true;
          await scancontrol.stop();
          if(!mounted)
          {
            return;
          }
          Navigator.pop(context, code);

        } ,
      ),
    );
  }
}