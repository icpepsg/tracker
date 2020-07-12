

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QR extends StatefulWidget {
  final String username;
  QR(this.username);

  @override
  _QRState createState() => _QRState(this.username);
}

class _QRState extends State<QR> {
  final String username;
  _QRState(this.username);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QrImage(
        data: this.username,
        version: QrVersions.auto,
        size: 220,
        gapless: true,
      ),
    );
  }



}