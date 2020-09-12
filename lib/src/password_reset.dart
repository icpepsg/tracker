import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import "package:flutter/material.dart";
import 'package:tracker/src/LoginPage.dart';
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/CommonTextWidget.dart';
import 'package:tracker/src/customwidget/CustomButton.dart';
import 'package:tracker/src/customwidget/ImageContainer.dart';
import 'package:tracker/src/model/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
class PasswordReset extends StatefulWidget {
  @override
  PasswordResetState createState() => new PasswordResetState();
}

class PasswordResetState extends State<PasswordReset> {
  final _formKey = GlobalKey<FormState>();
  UserModel userModel = new UserModel();
  bool visibilityEmail = true;

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        print("pressed nowwwww   $visibilityEmail");
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();


          if (visibilityEmail){
            http.Response result = await requestReset();
            Map userMap = jsonDecode(result.body);
            var data = UserModel.fromJson(userMap);
            print('##############################################################');
            print('Success = ${data.success}');
            print('Message =  ${data.message}.');
            if (data.success) {
              showToast(Colors.green,data.message.toString());
              setState(() {
                visibilityEmail = false;
              });
            }else{
              showToast(Colors.red,data.message.toString());
            }

          }else{
            http.Response result = await confirmReset();
            Map userMap = jsonDecode(result.body);
            var data = UserModel.fromJson(userMap);
            print('##############################################################');
            print('Success = ${data.success}');
            print('Message =  ${data.message}.');
            if (data.success) {
              showToast(Colors.green,data.message.toString());
              setState(() {
                visibilityEmail = true;
              });
              Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
            }else{
              showToast(Colors.red,data.message.toString());
            }
          }

          //Map userMap = jsonDecode(result.body);
          //var data = UserModel.fromJson(userMap);
          //print('##############################################################');
          //print('Success = ${data.success}');
          //print('Message =  ${data.message}.');
         // if (data.success) {
         //   showToast(Colors.green,data.message.toString());
         //   //Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
         // } else {
         //   showToast(Colors.red,data.message.toString());
         // }
        }


      },
      child: CustomButton(
        label: "SUBMIT",
      ),
    );
  }
  void showToast(Color bgColor,String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: bgColor,
        textColor: Colors.white,
        timeInSecForIosWeb: 3);
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
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
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'ICpEP Singapore',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.green[600]),
                  )),
            ],
          ),
        ),
        body: Form(
          key: _formKey,
          child: new ListView(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(vertical: 70),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Password Reset",
                   style: TextStyle(fontWeight: FontWeight.bold,
                       fontSize: 30,
                       color: Colors.green[600]))
                  ],
                ),
              ),
               Container(
                   width: MediaQuery.of(context).size.width * .8,
                  //margin: new EdgeInsets.only(left: 16.0, right: 16.0),
                  child:  Column(
                    children: <Widget>[
                      visibilityEmail ?  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            child: CommonTextWidget(
                              title: Constants.TXT_LABEL_USERNAME,
                              onSaved: (String value) {
                                userModel.email = value;
                              },
                              evaluator: (String value) {
                                if (value.isEmpty) {
                                  return Constants.MSG_ERROR_USERNAME;
                                } else if (!EmailValidator.validate(value)) {
                                  return Constants.MSG_ERROR_USERNAME_FMT;
                                }
                                return null;
                              },
                            ),
                          ),

                        ],
                      ) : new Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * .8,
                              child: CommonTextWidget(
                                title: Constants.TXT_LABEL_NEW_PASSWORD,
                                onSaved: (String value) {
                                  userModel.password = value;
                                },
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * .8,
                              child: CommonTextWidget(
                                title: Constants.TXT_LABEL_TOKEN,
                                onSaved: (String value) {
                                  userModel.token = value;
                                },
                              ),
                            ),
                          ],
                        ),

                      ),
//widget below email textbox
                    Container (
                      width: MediaQuery.of(context).size.width * .8,
                      child: _submitButton(),
                    )


                    ],
                  )
              ),

            ],
          ),
        )
    );
  }

  Future<http.Response> requestReset() async {
    print('==>>>' + userModelToJson(userModel));
    final resp = await http.post(Constants.API_URL_REQUEST_RESET,
        headers: {"Content-Type": "application/json"},
        body: userModelToJson(userModel));
    return resp;
  }
  Future<http.Response> confirmReset() async {
    print('==>>>' + userModelToJson(userModel));
    final resp = await http.post(Constants.API_URL_CONFIRM_RESET,
        headers: {"Content-Type": "application/json"},
        body: userModelToJson(userModel));
    return resp;
  }

}