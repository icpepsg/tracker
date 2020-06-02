import 'package:flutter/material.dart';
class ImageContainer extends StatelessWidget {
  final String assetLocation;
  //'assets/images/ct_logo.png'
  ImageContainer({this.assetLocation,});
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage(assetLocation);
    Image image = Image(image: assetImage);
    return Container(
        child: image
    );
  }
}