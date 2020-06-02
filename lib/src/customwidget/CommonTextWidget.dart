import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonTextWidget extends StatelessWidget {
  final String title;
  final bool isPassword,isNumeric;
  final Function onSaved, evaluator;

  CommonTextWidget({
    this.title,
    this.isPassword = false,
    this.isNumeric = false,
    this.onSaved,
    this.evaluator,
  });
  @override
  Widget build(BuildContext context) {


    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //Text(title,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          SizedBox(height: 5),
          TextFormField(
            obscureText: isPassword,
            onSaved: onSaved,
            keyboardType: isNumeric ? TextInputType.phone : TextInputType.text ,
            inputFormatters: isNumeric ? [LengthLimitingTextInputFormatter(11),] : [LengthLimitingTextInputFormatter(50),],

            //style: TextStyle(color: Colors.black,height: 1.0,),
            decoration: InputDecoration(
              hintText: title,
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
              border: InputBorder.none,
              fillColor: Colors.grey[200],
              filled: true,

            ),
            validator: evaluator,
          )
        ],
      ),
    );
  }




}