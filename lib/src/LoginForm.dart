import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/Signup.dart';
import 'package:tracker/src/bloc/login_bloc.dart';
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/CommonTextWidget.dart';
import 'package:tracker/src/customwidget/CustomButton.dart';
import 'package:tracker/src/customwidget/ImageContainer.dart';
import 'package:tracker/src/model/UserModel.dart';

class LoginForm extends StatefulWidget{
  LoginForm({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginFormState createState() => _LoginFormState();
}
class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _username; //TODO  : Change this to token on phase 2
  UserModel userModel = new UserModel();

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

  Future<void> _setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("token", token);
  }

  Future<void> _setPicture(String picture) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("picture", picture);
  }

  Future<String> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username');
  }
  void printUser() {
    _getUser().then((value) {
      print('username : $value');
    });
  }





  Widget _submitButton(BuildContext context) {
    // ignore: close_sinks
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          loginBloc.add(AuthLogin(userModel.username,userModel.password));
        }
        //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      },
      child: CustomButton(
        label: Constants.TXT_BUTTON_LOGIN,
      ),
    );
  }


  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Constants.TXT_LABEL_NO_ACCOUNT,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          SizedBox(width: 10),
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Signup()));
            },
            child: Text(
              Constants.TXT_LABEL_REGISTER,
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
                  child: Column(children: <Widget>[
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
                        onSaved: (String value) {
                          userModel.username = value;
                        },
                        evaluator: (String value) {
                          if (value.isEmpty) {
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
                        onSaved: (String value) {
                          userModel.password = value;
                        },
                        evaluator: (String value) {
                          if (value.isEmpty) {
                            return Constants.MSG_ERROR_PASSWORD;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    _submitButton(context),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: Text(Constants.TXT_LABEL_FORGOT_PASSWORD,
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
                            Buttons.GoogleDark,
                            onPressed: () {
// call google sign in here
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          SignInButton(Buttons.Facebook,
                              onPressed: () async {
//  To Add in this one
                                print('try logging in to facebook');
                              })
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
  }
}