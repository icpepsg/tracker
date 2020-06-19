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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: BlocProvider(
            builder: (context) => LoginBloc(LoginService()),
            child: Container(child:
                // ignore: missing_return
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              if (state is LoginInit) {
                return LoginForm();
              } else if (state is LoginIsLoading)
                return Scaffold(
                    body: Container(
                        child: Center(child: CircularLoadingAnimation())));
              else if (state is LoginIsLoaded)
                return Home();
              else if (state is LoginError)
                return Login();
            }))),
      ),
    ),debugShowCheckedModeBanner: false,);
  } // end build

}


class Login extends StatelessWidget {
  final LoginService loginService;

  Login({Key key, @required this.loginService})
      :   super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocProvider(
        create: (context) {
          return LoginBloc(LoginService());
        },
        child: LoginForm(),
      ),


    );
  }
}