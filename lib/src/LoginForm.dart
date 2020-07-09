import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:tracker/src/model/UserModel.dart';
import 'package:tracker/src/service/login_service.dart';

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
  _LoginFormState(this.loginService);

  @override
  void initState() {
    super.initState();
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => Signup()));
            },
            child: Text(
              Constants.TXT_LABEL_REGISTER,
              style: TextStyle(
                  color: Colors.red, fontSize: fontSize, fontWeight: FontWeight.w600),
            ),
          )
        ],
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
  Widget build(BuildContext context) {
    final loginBloc = BlocProvider.of<LoginBloc>(context);
    double logoHeight = MediaQuery.of(context).size.height * .2;
    double logoWidth  = MediaQuery.of(context).size.width * .2;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = MediaQuery.of(context).size.height*0.1;
    double font,labelSize;
    if (screenHeight <= 500) {
      height = 5;
      font = 10;
      logoHeight = MediaQuery.of(context).size.height * .1;
    }
    else if (screenHeight <= 600) {
      height = 10;
       font = 12;
      labelSize = 10;
      logoHeight = MediaQuery.of(context).size.height * .2;
    }else {
      height = 20;
      font = 15;
      labelSize = 13;
      logoHeight = MediaQuery.of(context).size.height * .25;
    }

    return BlocListener<LoginBloc, LoginState>(

        listener: (context, state) {
      if (state is LoginError) {
        _setUser(null);
        showToast(Colors.red,state.getMessage);
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('${state.getMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }else if (state is LoginIsLoaded){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
      }
    }, child: BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {

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
                                if (value.isEmpty) {
                                  return Constants.MSG_ERROR_PASSWORD;
                                }
                                return null;
                              },
                            ),
                          ),
                          _submitButton(context),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.centerRight,
                            child: Text(Constants.TXT_LABEL_FORGOT_PASSWORD,
                                style: TextStyle(
                                    fontSize: labelSize,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.redAccent)),
                          ),
                          Container(
                            child: Column(
                              children: <Widget>[
                                //new Text(' '),
                                SignInButton(
                                  Buttons.Google,
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
                            child: _createAccountLabel(labelSize),
                          ),
                        ]))),
              )));
    }));
  }
}
