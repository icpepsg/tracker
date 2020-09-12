import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/Home.dart';
import 'package:tracker/src/Signup.dart';
import 'package:tracker/src/bloc/login_bloc.dart';
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/CommonTextWidget.dart';
import 'package:tracker/src/customwidget/CustomButton.dart';
import 'package:tracker/src/customwidget/ImageContainer.dart';
import 'package:tracker/src/model/FbModel.dart';
import 'package:tracker/src/model/UserModel.dart';
import 'package:tracker/src/password_reset.dart';
import 'package:tracker/src/service/login_service.dart';
import 'package:http/http.dart' as http;
class LoginForm extends StatefulWidget {
  final LoginService loginService;
  LoginForm({Key key, @required this.loginService}) : super(key: key);
  //LoginForm({Key key, this.title, this.errMssage}) : super(key: key);
  //final String errMssage;
  //final String title;

  @override
  _LoginFormState createState() => _LoginFormState(this.loginService);
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<String> _username; //TODO  : Change this to token on phase 2
  UserModel userModel = new UserModel();
  LoginService loginService;
  bool fbLoading = false;
  _LoginFormState(this.loginService);
  LoginBloc loginBloc;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    _username = _prefs.then((SharedPreferences prefs) {
      return (prefs.getString('username') ?? null);
    });
    //printUser();
    DateTime now = new DateTime.now();
    print('now => ' + now.toString());
  }

  Future<void> _setUser(String user) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("username", user);
  }

  Future<void> _setToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("fbtoken", token);
  }

  Future<void> _setPicture(String url) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString("profilePhoto", url);
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
    //final loginBloc = BlocProvider.of<LoginBloc>(context);
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          _setUser(userModel.username);
          loginBloc.add(AuthLogin(userModel.username, userModel.password));

        }
      },
      child: CustomButton(
        label: Constants.TXT_BUTTON_LOGIN,
      ),
    );
  }

  Widget _createAccountLabel(double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Constants.TXT_LABEL_NO_ACCOUNT,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
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
                  color: Colors.red,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _resetPasswordLabel(double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PasswordReset()));
            },
            child: Text(
              Constants.TXT_LABEL_FORGOT_PASSWORD,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  void showToast(Color bgColor, String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: bgColor,
        textColor: Colors.white,
        timeInSecForIosWeb: 3);
  }

  @override
  Widget build(BuildContext context) {
    //final loginBloc = BlocProvider.of<LoginBloc>(context);
    double logoHeight = MediaQuery
        .of(context)
        .size
        .height * .2;
    double logoWidth = MediaQuery
        .of(context)
        .size
        .width * .2;
    double screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    double height = MediaQuery
        .of(context)
        .size
        .height * 0.1;
    double font, labelSize;
    if (screenHeight <= 500) {
      height = 5;
      font = 10;
      logoHeight = MediaQuery
          .of(context)
          .size
          .height * .1;
    }
    else if (screenHeight <= 600) {
      height = 10;
      font = 12;
      labelSize = 10;
      logoHeight = MediaQuery
          .of(context)
          .size
          .height * .2;
    } else {
      height = 20;
      font = 15;
      labelSize = 13;
      logoHeight = MediaQuery
          .of(context)
          .size
          .height * .25;
    }
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          print('im at state listener... ' +state.toString());
          if (state is LoginError) {
            _setUser(null);
            showToast(Colors.red, state.getMessage);
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.getMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is LoginIsLoaded) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          }else if (state is LoggedInFB) {
            _setUser(state.getCredential);
            Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
          }
        },
        // ignore: missing_return
        child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {

      return Form(
          key: _formKey,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                child: SafeArea(
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Column(children: <Widget>[
                          SizedBox(
                            height: height,
                          ),
                          Container(
                            alignment: Alignment.center,
                            height: logoHeight,
                            child: ImageContainer(
                              assetLocation: Constants.IMG_TRACKER,
                            ),
                          ),
                          SizedBox(
                            height: height,
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
                                } else if (!EmailValidator.validate(value)) {
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
                                if (value.isEmpty) {
                                  return Constants.MSG_ERROR_PASSWORD;
                                }
                                return null;
                              },
                            ),
                          ),
                          _submitButton(context),
                          Container(
                            //padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: _resetPasswordLabel(labelSize)

                          ),
//                          Container(
//                            child: Column(
//                              children: <Widget>[
//                                //new Text(' '),
//                                SignInButton(
//                                  Buttons.Google,
//                                  onPressed: () {
// call google sign in here
//                                  },
 //                               )
//                              ],
//                            ),
//                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                SignInButton(Buttons.Facebook,
                                    onPressed: () async {
//  To Add in this one
                                      //_loginFB();
                                      //Navigator.push(context, MaterialPageRoute(builder: (context) => FBLogin()));
                                      loginBloc.add(FBLogin());
                                      print('try logging in to facebook');
                                    }
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: _createAccountLabel(labelSize),
                          ),
                        ]))),
              )));
    }));
  }

  Future<Null> _loginFB() async {
    // please do not remove this code i need  it as backup or reference - Kelvin
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResp = await http.get(Constants.API_URL_FACEBOOK_TOKEN + token);
        if (result.status == FacebookLoginStatus.loggedIn) {
          Map fbMap = jsonDecode(graphResp.body);
          var data = FbModel.fromJson(fbMap);
          Map photo = data.picture.toJson();
          var photoUrl = Picture.fromJson(photo);
          _setToken(token);
          _setUser(data.email);
          _setPicture(photoUrl.data.url);
          print("photo => " + photo.toString());
          print("Email => " + data.email);
          Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        }
        print('loggedIn');
        // TODO: Handle this case.
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancelledByUser');
        break;
      case FacebookLoginStatus.error:
        print('error : ' + result.errorMessage);
        await facebookSignIn.logOut();
        print('logOut : ');
        break;
    }
  }
}
