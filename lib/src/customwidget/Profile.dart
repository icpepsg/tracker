import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/LoginPage.dart';

class Profile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }

}

class _ProfileState extends State<Profile> {



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
                                 image: new NetworkImage(
                                     "https://thumbs.dreamstime.com/z/gentleman-avatar-profile-icon-image-default-user-hairstyle-vector-illustration-182197665.jpg")
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
                          color: Colors.lightGreen,
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

