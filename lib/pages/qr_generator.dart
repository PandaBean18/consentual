import "package:flutter/material.dart";
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:math';

class QrGenerator extends StatefulWidget {
  @override  
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  var encString;  

  @override  
  void initState() {
    super.initState();
    var r = Random.secure();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    encString = List.generate(16, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: encString,
      version: QrVersions.auto,
      size: ((MediaQuery.of(context).size.width - 150) < 0 ? 425 : (MediaQuery.of(context).size.width - 150)),
      eyeStyle: QrEyeStyle(
        color: Theme.of(context).colorScheme.secondary
      ),
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Theme.of(context).colorScheme.secondary
      ),
    );
  }
} 
