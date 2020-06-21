import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/CommonTextWidget.dart';
import 'package:tracker/src/customwidget/CustomButton.dart';
import 'package:tracker/src/model/UserModel.dart';
import '../LoginPage.dart';
/*
 Author : kelvin Co
 */

class CustomFormWidget extends StatefulWidget {
  @override
  _CustomFormWidget createState() => _CustomFormWidget();
}

class _CustomFormWidget extends State<CustomFormWidget> {
  final _formKey = GlobalKey<FormState>();
  UserModel userModel = new UserModel();
  String deviceID, hardware, brand, id, identifierForVendor;
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  _CustomFormWidget();

  @override
  void initState() {
    super.initState();
  }




  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();

          http.Response result = await submitData();
          Map userMap = jsonDecode(result.body);
          var data = UserModel.fromJson(userMap);
          print(
              '##############################################################');
          print('Success = ${data.success}');
          print('Message =  ${data.message}.');
          if (data.success) {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("Success"),
                      content: Text(Constants
                          .MSG_SUCCESS_NEW_ACCOUNT), // can be replaced by message from API
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop(); //close Dialog box before moving to next page
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          },
                        )
                      ],
                    ));
          } else {
            showDialog(
                context: context,
                builder: (_) => AlertDialog(
                      title: Text("Failed"),
                      content: Text(data.message.toString()),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop(); //close Dialog box before moving to next page

                          },
                        )
                      ],
                    ));
          }
        }
      },
      child: CustomButton(
        label: Constants.TXT_BUTTON_REGISTER,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        Container(
          child: CommonTextWidget(
            title: Constants.TXT_LABEL_USERNAME,
            onSaved: (String value) {
              userModel.username = value;
            },
            evaluator: (String value) {
              if (value.isEmpty) {
                return Constants.MSG_ERROR_USERNAME;
              }else if(!EmailValidator.validate(value)){
                return Constants.MSG_ERROR_USERNAME_FMT;
              }
              return null;
            },
          ),
        ),
        Container(
          child: CommonTextWidget(
            title: Constants.TXT_LABEL_PASSWORD,
            isPassword: true,
            onSaved: (String value) {
              userModel.password = value;
            },
            evaluator: (String value) {
              if (value.length < 8) {
                return Constants.MSG_ERROR_PASSWORD_FMT;
              }
              _formKey.currentState.save();
              return null;
            },
          ),
        ),
        Container(
          child: CommonTextWidget(
            title: Constants.TXT_LABEL_CONFIRM_PASSWORD,
            isPassword: true,
            evaluator: (String value) {
              if (value.length < 8) {
                return Constants.MSG_ERROR_PASSWORD;
              } else if (userModel.password != null &&
                  userModel.password != value) {
                return Constants.MSG_ERROR_MISMATCH;
              }
              return null;
            },
          ),
        ),
        Container(
          child: _submitButton(),
        ),
      ]),
    );
  }

  Future<http.Response> submitData() async {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
        setState(() {
          deviceID = androidDeviceInfo.androidId.toString();
        },
        );
      } else if (Platform.isIOS) {
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        setState(() {
          print('identifierForVendor: ${iosDeviceInfo.identifierForVendor}');
          identifierForVendor=iosDeviceInfo.identifierForVendor.toString();
        },
        );
      }
    } on PlatformException {
      print('Error: Failed to get platform version.');
    }

    if (Platform.isAndroid)
      userModel.device_id = deviceID;
    else if (Platform.isIOS)
      userModel.device_id = identifierForVendor;
    print('==>>>' + userModelToJson(userModel));
    final resp = await http.post(Constants.API_URL_SIGN_UP,
        headers: {"Content-Type": "application/json"},
        body: userModelToJson(userModel));
    return resp;
  }
}
