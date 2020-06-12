import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    double width = MediaQuery.of(context).size.width * 0.7;
    double topPadding = MediaQuery.of(context).size.height * 0.1;
    double topContent = MediaQuery.of(context).size.height * 0.2;
    double midContent = MediaQuery.of(context).size.height * 0.5;
    double botContent = MediaQuery.of(context).size.height * 0.2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
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
                    )


                  ),

                  Container(
                    height: midContent,
                    width: width,
                    child: CustomFormWidget(),
                  ),

                  Container(
                  height: botContent,
                  //alignment: Alignment.bottomCenter,
                  child: _loginAccountLabel(),
                  ),

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
