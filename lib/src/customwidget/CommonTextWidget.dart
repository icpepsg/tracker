import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/*
 Author : kelvin Co
 */
class CommonTextWidget extends StatelessWidget {
  final String title;
  final bool isPassword,isNumeric,isEmail;
  final Function onSaved, evaluator;

  CommonTextWidget({
    this.title,
    this.isPassword = false,
    this.isNumeric = false,
    this.onSaved,
    this.evaluator,
    this.isEmail= false,
  });
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    double font,inset,errorSize,height;
    if (screenHeight <= 600) {
      errorSize = 7;
      font = 12;
      inset = 10;
      height = MediaQuery.of(context).size.height*0.11;
    }else {
      errorSize = 10;
      font = 15;
      inset=15;
      height = MediaQuery.of(context).size.height*0.10;
    }
    return Container(
      height: height,
      //margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Text(title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          SizedBox(height: 5),
          TextFormField(
            obscureText: isPassword,
            onSaved: onSaved,
            keyboardType: isNumeric ? TextInputType.phone : TextInputType.emailAddress ,
            inputFormatters: isNumeric ? [LengthLimitingTextInputFormatter(11),] : [LengthLimitingTextInputFormatter(50),],
            style: TextStyle(color: Colors.black,fontSize: font),
            decoration: InputDecoration(
              isDense: true,
              hintText: title,
              contentPadding: EdgeInsets.all(inset),
              //contentPadding: EdgeInsets.symmetric(horizontal: 15),
              //border: InputBorder.none,
              fillColor: Colors.grey[200],
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              errorStyle: TextStyle(
                fontSize: errorSize,
              ),
            ),
            validator: evaluator,
          )
        ],
      ),
    );
  }




}