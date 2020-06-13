import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/CommonTextWidget.dart';
import 'package:tracker/src/customwidget/CustomButton.dart';
import 'package:tracker/src/model/UserModel.dart';
import 'Home.dart';
import 'Signup.dart';
import 'package:tracker/src/customwidget/ImageContainer.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';

/*
 Author : kelvin Co
 */

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _username; //TODO  : Change this to token on phase 2

  UserModel userModel = new UserModel();
  final _formKey = GlobalKey<FormState>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  void initState() {
    super.initState();
    _username = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('username') ?? null);
    });
    //printUser();
  }

  Future<void> _setUser(String user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("username", user);
  }

  Future<String> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username');
  }
  void printUser(){
    _getUser().then((value) {
    print('username : $value');
    });
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        if(_formKey.currentState.validate()) {
          _formKey.currentState.save();
          http.Response result = await submitData();
          Map userMap = jsonDecode(result.body);
          var data = UserModel.fromJson(userMap);

          if(data.success.toString()=="1"){
            showDialog(context: context,
                builder: (_)=> AlertDialog(
                  title: Text("Success"),
                  content: Text("Login Successful"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("OK"),
                      onPressed: () async {
                        _setUser(userModel.username);
                        Navigator.of(context).pop(); //close Dialog box before moving to next page
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                      },
                    )
                  ],
                )
            );
          }else{
            showDialog(context: context,
                builder: (_)=> AlertDialog(
                  title: Text("Failed!"),
                  content: Text(data.message.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: (){
                        Navigator.of(context).pop(); //close Dialog box before moving to next page
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                      },
                    )
                  ],
                )
            );
          }

        }
        //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      },
      child: CustomButton(
        label: Constants.TXT_BUTTON_LOGIN,
      ),
    );
  }
  Future<http.Response> submitData() async{
    final resp = await http.post(Constants.API_URL_LOGIN,body: signupModelToJson(userModel).toString());
    return resp;
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(Constants.TXT_LABEL_NO_ACCOUNT,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Signup()));
            },
            child: Text(Constants.TXT_LABEL_REGISTER,
              style: TextStyle(color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  height: 200.0,
                  child: ImageContainer(
                    assetLocation: Constants.IMG_TRACKER,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: CommonTextWidget(
                    title: Constants.TXT_LABEL_USERNAME,
                    onSaved: (String value){
                      userModel.username=value;
                    },
                    evaluator: (String value){
                      if (value.isEmpty){
                        return Constants.MSG_ERROR_USERNAME;
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  child: CommonTextWidget(
                    title: Constants.TXT_LABEL_PASSWORD,
                    isPassword: true,
                    onSaved: (String value){
                      userModel.password=value;
                    },
                    evaluator: (String value){
                      if (value.isEmpty){
                        return Constants.MSG_ERROR_PASSWORD;
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _submitButton(),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerRight,
                  child: Text(Constants.TXT_LABEL_FORGOT_PASSWORD,
                      style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500, color: Colors.redAccent)),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      new Text(' '),
                      SignInButton(
                        Buttons.Google,
                        onPressed: (){
                          // call google sign in here
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      SignInButton(
                        Buttons.Facebook,
                        onPressed: () async {
                          //  To Add in this one
                           _login();
                          print('try logging in to facebook');
                        }
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: _createAccountLabel(),
                ),

              ]
          )
        )
        )
      ),
    );


  }// end build
  void _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    final token = result.accessToken.token;
    final graphResp = await http.get(Constants.API_URL_FACEBOOK_TOKEN +token);
    print('graphResp => '+graphResp.body);
    if(result.status==FacebookLoginStatus.loggedIn){
      //final credential = FacebookAuthProvider.getCredential(accessToken: token);
      print("its logged in");
      Map userMap = jsonDecode(graphResp.body);
      var data = UserModel.fromJson(userMap);
      print("Email => " +data.email);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }

  }



}
