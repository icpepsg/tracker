import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;

  const CustomButton({Key key, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double font,inset,height;
    if (screenHeight <= 600) {
      font = 13;
      inset = 10;
      height = 35;
    }else {
      font = 20;
      inset = 15;
      height = 50;
    }

    return Container(
      width: MediaQuery.of(context).size.width ,
      height: height,
      padding: EdgeInsets.all(inset),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.green[600]),
      child: Text(label,
        style: TextStyle(
            fontSize: font, color: Colors.white, fontWeight: FontWeight.bold),
      ),

    );
     }
  }