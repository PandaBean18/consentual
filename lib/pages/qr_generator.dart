import "package:flutter/material.dart";
import 'package:qr_flutter/qr_flutter.dart';

class QrGenerator extends StatefulWidget {
  final String? userConsentualId;
  const QrGenerator({required this.userConsentualId, super.key});
  @override  
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  
  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: widget.userConsentualId!,
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
