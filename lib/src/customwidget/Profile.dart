import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/LoginPage.dart';
import 'package:tracker/src/SplashScreen.dart';
import 'package:tracker/src/common/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:tracker/src/model/UserModel.dart';
class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }

}

class _ProfileState extends State<Profile> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  static FacebookLogin get facebookSignIn => new FacebookLogin();
  String photoUrl = Constants.API_URL_DEFAULT_PHOTO;



  bool isFbPhotoAvailable = false;
  @override
  void initState(){
    super.initState();
    printPref();
    Timer(Duration(seconds: 5), () {
      print ('wait for the photo to  be initialized...');
    });

  }
  Future<String> _getPref() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString('picture');
  }
  void printPref(){
    _getPref().then((value) {
      print('picture : $value');
      photoUrl = value;
    });

  }
    @override
    Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width * 0.8;
      double height = MediaQuery.of(context).size.height * 0.7;
      double topContent = (height) * 0.3;
      double midContent = (height) * 0.6;
      double botContent = (height) * 0.1;
      return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Container(
                  height: topContent,
                  width: width,
                 child: Row(
                   children: [
                     Container(
                         width: width * .4,
                         height: topContent *.8,
                         decoration: new BoxDecoration(
                             shape: BoxShape.circle,
                             image: new DecorationImage(
                                 fit: BoxFit.fill,
                                 image: new NetworkImage(photoUrl)
                             )
                         )),
                     Container(
                       child: SizedBox(
                         //width: width,
                         height: topContent,
                         child: const DecoratedBox(
                           decoration: const BoxDecoration(
                             color: Colors.lightBlue,
                           ),
                         ),
                       )
                     )
                   ],
                 ),

                ),
                Container(
                    child:SizedBox(
                      width: width,
                      height: midContent,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(
                          color: Colors.lightBlueAccent,
                        ),
                      ),
                    )
                ),
                Container(
                  //width: width,
                  height: botContent,
                  child: RaisedButton(
                      textColor: Colors.white,
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.lightBlueAccent,
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        child:
                        const Text('Log out', style: TextStyle(fontSize: 20)),
                      ),
                      onPressed: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove("username");
                        prefs.clear();
                        await facebookSignIn.logOut();

                        Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                      }
                  ),
                ),
              ],


            )
          ),
        )
      );
    }
  }

