import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tracker/src/model/UserModel.dart';


import '../LoginPage.dart';


class CustomFormWidget extends StatefulWidget {
  @override
  _CustomFormWidget createState() => _CustomFormWidget();
}

class _CustomFormWidget extends State<CustomFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final int httpSuccess = 200;
  UserModel userModel = new UserModel();

  Widget _submitButton() {
    return InkWell(
      onTap: () async{
        if(_formKey.currentState.validate()){
          _formKey.currentState.save();
          http.Response result = await submitData();
          Map userMap = jsonDecode(result.body);
          var data = UserModel.fromJson(userMap);
          print('##############################################################');
          print('Success = ${data.success}');
          print('Message =  ${data.message}.');
          if(data.success.toString()=="1"){
            showDialog(context: context,
                builder: (_)=> AlertDialog(
                  title: Text("Success"),
                  content: Text("Account Successfully Created. Please login with your account"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: (){
                        Navigator.of(context).pop(); //close Dialog box before moving to next page
                         Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                       // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                      },
                    )
                  ],
                ));
          }else{
            showDialog(context: context,
                builder: (_)=> AlertDialog(
                  title: Text("Failed"),
                  content: Text(data.message.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: (){
                        Navigator.of(context).pop(); //close Dialog box before moving to next page
                      },
                    )
                  ],
                ));
          }

        }
      },
      child:Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.green.withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.green[600]),
        child: Text(
          'Register Now',
          style: TextStyle( fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final halfScreen = (MediaQuery.of(context).size.width - 50) / 2.0;
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Container(
          child: MultiTextForm(
            title: 'Username',
            onSaved: (String value){
              userModel.username=value;
            },
            evaluator: (String value){
              if (value.isEmpty){
                return 'Please enter a Username';
              }
              return null;
            },
          ),
        ),




        Container(
          child: MultiTextForm(
            title: 'Password',
            isPassword: true,
            onSaved: (String value){
              userModel.password=value;
            },
            evaluator: (String value){
              if (value.length < 8){
                return 'Please enter a minimum 8 character password';
              }
              _formKey.currentState.save();
              return null;
            },
          ),
        ),
        Container(
          child: MultiTextForm(
            title: 'Confirm Password',
            isPassword: true,
            evaluator: (String value){
              if (value.length < 8){
                return 'Please enter Password';
              }else if(userModel.password!=null && userModel.password != value){
                return 'Password does not match';
              }
              return null;
            },
          ),
        ),
        Row (
          children: <Widget>[
            Container(
              width: halfScreen,
              child: MultiTextForm(
                title: 'First Name',
                onSaved: (String value){
                  userModel.firstname=value;
                },
                evaluator: (String value){
                  if (value.isEmpty){
                    return 'Please enter your First Name';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Container(
              width: halfScreen,
              child: MultiTextForm(
                title: 'Middle Name',
                onSaved: (String value){
                  userModel.firstname=value;
                },
              ),
            ),
          ],
        ),

        Container(
          child: MultiTextForm(
            title: 'Last Name',
            onSaved: (String value){
              userModel.lastname=value;
            },
            evaluator: (String value){
              if (value.isEmpty){
                return 'Please enter your Last Name';
              }
              return null;
            },
          ),
        ),
        Container(
          child: MultiTextForm(
            title: 'E-Mail Address',
            onSaved: (String value){
              userModel.email=value;
            },
          ),
        ),
        Container(
          child: MultiTextForm(
            title: 'Mobile Number',
            isNumeric:true,
            onSaved: (String value){
              userModel.mobileno=value;
            },
            evaluator: (String value){
              if (value.isEmpty){
                return 'Please enter Mobile Number';
              }else if(value.length < 11||value.length>11){
                return 'Please enter a Valid 11 Digit Mobile Number';
              }
              return null;
            },
          ),
        ),

        // button
        SizedBox(
          height: 150,
        ),
        _submitButton(),
        SizedBox(
          height: 20,
        ),
      ]),
    );
  }

  Future<http.Response> submitData() async{
    String url = 'http://kelvinco.ml/webapp/ct_signup.php';
    //String header = 'Content-Type\': \'application/json; charset=UTF-8\'';
    final resp = await http.post(url,body: signupModelToJson(userModel).toString());
    return resp;
  }


}

class MultiTextForm extends StatelessWidget {
  final String title;
  final bool isPassword,isNumeric;
  final Function onSaved, evaluator;

  MultiTextForm({
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
