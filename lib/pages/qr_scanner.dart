import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/material.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override  
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode? barcode;

  @override
  Widget build(BuildContext context) {
    return 
     MobileScanner(
      fit: BoxFit.cover,
      onDetect: (barcodes) => {
        print(barcodes.barcodes.first.displayValue)
      },
    );
  }
}