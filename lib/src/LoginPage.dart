import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracker/src/LoginForm.dart';
import 'package:tracker/src/bloc/login_bloc.dart';
import 'package:tracker/src/customwidget/CircularLoadingAnimation.dart';
import 'package:tracker/src/service/login_service.dart';
import 'Home.dart';

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
  // final _formKey = GlobalKey<FormState>();


  LoginService loginService;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: BlocProvider(
                create: (context) => LoginBloc(LoginService()),
                child: Container(child:
                    BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return LoginForm();
                }))),
          ),
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  } // end build

}

