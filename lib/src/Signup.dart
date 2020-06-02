import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'customwidget/CustomFormWidget.dart';
import 'loginPage.dart';

class Signup extends StatefulWidget {
  Signup({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {


  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Already have an account ?',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
              'Login',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Community Tracker',
        style: GoogleFonts.courierPrime(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w100,
          color: Colors.green,
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  _title(),
                  SizedBox(
                    height: 10,
                  ),
                  CustomFormWidget(),
                  SizedBox(
                    height: 10,
                  ),
                  _loginAccountLabel(),
                  /*                   _signUpFormdWidget(),
                    SizedBox(
                      height: 10,
                    ),
                    _submitButton(),

                    _loginAccountLabel(),
*/                  ],

              ),
            ),



          )
      ),
    );
  }



}
