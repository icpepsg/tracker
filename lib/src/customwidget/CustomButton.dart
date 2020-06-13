import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;

  const CustomButton({Key key, this.label}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery
          .of(context)
          .size
          .width,
      padding: EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.green.withAlpha(100),
                offset: Offset(2, 4),
                blurRadius: 1,
                spreadRadius: 1)
          ],
          color: Colors.green[600]),
      child: Text(label,
        style: TextStyle(
            fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
      ),

    );
     }
  }