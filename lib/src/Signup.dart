import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tracker/src/common/Constants.dart';
import 'customwidget/CustomFormWidget.dart';
import 'loginPage.dart';

/*
 Author : kelvin Co
 */
class Signup extends StatefulWidget {
  Signup({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  Widget _loginAccountLabel(double fontSize) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Constants.TXT_LABEL_GOT_ACCOUNT,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginPage()));
            },
            child: Text(
              Constants.TXT_BUTTON_LOGIN,
              style: TextStyle(
                  color: Colors.red, fontSize: fontSize, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    double screenHeight = MediaQuery.of(context).size.height;
    double font;
    if (screenHeight <= 600) {
      font = 20;
    }else {
      font = 30;
    }

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: Constants.TXT_APP_TITLE,
        style: GoogleFonts.courierPrime(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: font,
          fontWeight: FontWeight.w700,
          color: Colors.green[700],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.7;
    double topPadding = MediaQuery.of(context).size.height * 0.1;
    double topContent = MediaQuery.of(context).size.height * 0.2;
    double midContent = MediaQuery.of(context).size.height * 0.5;
    double botContent = MediaQuery.of(context).size.height * 0.1;
    double screenHeight = MediaQuery.of(context).size.height;
    double height = MediaQuery.of(context).size.height*0.1;
    double font,labelSize;
    if (screenHeight <= 500) {
      height = 5;
      font = 10;
      labelSize = 8;
    }
    else if (screenHeight <= 600) {
      height = 10;
      font = 12;
      labelSize = 10;
    }else {
      height = 20;
      font = 15;
      labelSize = 13;
    }
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          //           child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: topContent,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: topPadding,
                      ),
                      _title(),
                    ],
                  )),
              SizedBox(
                height: midContent,
                width: width,
                child: CustomFormWidget(),
              ),
              Container(
                height: botContent,
                child: _loginAccountLabel(labelSize),
              ),
            ],
          ),
          //     ),
        )),
      ),
    );
  }
}
