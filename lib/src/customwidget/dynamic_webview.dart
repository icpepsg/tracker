import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/ImageContainer.dart';
import 'package:webview_flutter/webview_flutter.dart';


class DynamicWebview extends StatefulWidget {
  final String url;
  DynamicWebview(this.url);

  @override
  _DynamicWebviewState createState() => _DynamicWebviewState(this.url);
}

class _DynamicWebviewState extends State<DynamicWebview> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  final Set<String> _favorites = Set<String>();
  final String url;
  _DynamicWebviewState(this.url);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              height: 45,
              child: ImageContainer(assetLocation: Constants.IMG_ICPEP),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0), child: Text('ICpEP Singapore',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.green[600]),)
            ),
          ],
        ),
      ),
      body: WebView(
        initialUrl: this.url,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
      //  floatingActionButton: _scrollToTop(),
    );
  }


}