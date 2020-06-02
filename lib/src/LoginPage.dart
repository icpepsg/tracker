import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:http/http.dart' as http;
import 'package:tracker/src/customwidget/CommonTextWidget.dart';
import 'package:tracker/src/model/UserModel.dart';
import 'Home.dart';
import 'Signup.dart';
import 'package:tracker/src/customwidget/ImageContainer.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';
class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  UserModel userModel = new UserModel();
  final _formKey = GlobalKey<FormState>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

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
                      child: Text("Ok"),
                      onPressed: (){
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13,horizontal: 20),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.green.withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.green[700]),
        child: Text(
          'Login',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  Future<http.Response> submitData() async{
    String url = 'http://kelvinco.ml/webapp/login.php';
    final resp = await http.post(url,body: signupModelToJson(userModel).toString());
    return resp;
  }



  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Don\'t have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Signup()));
            },
            child: Text(
              'Register',
              style: TextStyle(
                  color: Colors.red, fontSize: 13, fontWeight: FontWeight.w600),
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
                    assetLocation: 'assets/images/ct_logo.png',
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: CommonTextWidget(
                    title: 'Username',
                    onSaved: (String value){
                      userModel.username=value;
                    },
                    evaluator: (String value){
                      if (value.isEmpty){
                        return 'Please enter your Username!';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  child: CommonTextWidget(
                    title: 'Password',
                    isPassword: true,
                    onSaved: (String value){
                      userModel.password=value;
                    },
                    evaluator: (String value){
                      if (value.isEmpty){
                        return 'Please enter a  password!';
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
                  child: Text('Forgot Password ?',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.redAccent)),
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
                      new Text(' '),
                      new Text('------  or  ------',style: TextStyle(color: Colors.red),),
                      new Text(' '),
                      SignInButton(
                        Buttons.Facebook,
                        onPressed: (){
                          //  To Add in this one
                          // _login();
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
    final graphResp = await http.get('https://graph.facebook.com/v2.3/me?fields=name,first_name,email&access_token=' +token);
    print(graphResp.body);
    if(result.status==FacebookLoginStatus.loggedIn){
      //final credential = FacebookAuthProvider.getCredential(accessToken: token);
      print("its logged in");
    }

  }



}
