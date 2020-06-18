import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tracker/src/LoginForm.dart';
import 'package:tracker/src/bloc/login_bloc.dart';
import 'package:tracker/src/customwidget/CircularLoadingAnimation.dart';
import 'package:tracker/src/service/login_service.dart';
import 'Home.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
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
  final _formKey = GlobalKey<FormState>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  @override
  Widget build(BuildContext context) {
    //final loginBloc = BlocProvider.of<LoginBloc>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: BlocProvider(
            builder: (context) => LoginBloc(LoginService()),
            child: Container(
                child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
              if (state is LoginInit) {
                return LoginForm();
              } else if (state is LoginIsLoading)
                return Scaffold(
                    body: Container(
                        child: Center(child: CircularLoadingAnimation())));
              else if (state is LoginIsLoaded)
                return Home();
              else
                return Text(
                  'i don\'t know what happen',
                  style: TextStyle(color: Colors.white),
                );
            }
            )
        )
      ),
      ),
    );
  } // end build

}
