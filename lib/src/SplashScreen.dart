import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/LoginPage.dart';
import 'package:tracker/src/customwidget/CircularLoadingAnimation.dart';

import 'Home.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () {
      printUser();
    });

  }
  Future<String> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('username');
  }
  void printUser(){
    _getUser().then((value) {
      print('username : $value');
      if(value!=null){
        Navigator.of(context).push(MaterialPageRoute (builder: (context) => Home()));
      }else{
        Navigator.of(context).push(MaterialPageRoute (builder: (context) => LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                ],
              ),
              Center(
                child: Column(
                  children: <Widget>[
                    CircularLoadingAnimation(),
                  ],
                ),
              ),
              //CircleProgress(),
            ],
          ),
        ],
      ),
    );
  } // end build

}
