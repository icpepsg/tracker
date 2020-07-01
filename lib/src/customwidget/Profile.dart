import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/LoginPage.dart';
import 'package:tracker/src/history_page.dart';
import 'package:tracker/src/settings.dart';

class Profile extends StatefulWidget {
  Profile({Key key}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static FacebookLogin get facebookSignIn => new FacebookLogin();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String username;
  @override
  void initState() {
    super.initState();
    printUser();
  }
  Future<String> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    username=prefs.getString('username');
    return prefs.getString('username');
  }
  void printUser(){
    _getUser().then((value) {
      print('username : $value');
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getUser(),
      builder: (context,snapshot){
        return (username!=null) ? Scaffold(
            body: Stack(children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.grey[200], Colors.grey[300]])),
              ),
              Container(
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                        height: MediaQuery.of(context).size.height * .2,
                        width: MediaQuery.of(context).size.width * .9,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white, Colors.white]),
                            borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(20.0),
                                topRight: const Radius.circular(20.0))),
                        child:
                        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                          Center(
                              child: Text(username)
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ])),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .5,
                      width: MediaQuery.of(context).size.width * .9,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Colors.white]),
                          borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(20.0),
                              bottomRight: const Radius.circular(20.0))),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.history),
                            title: Text('History'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            enabled: true,
                            onTap: () {Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryPage()));},
                          ),
                          ListTile(
                              leading: Icon(Icons.info_outline),
                              title: Text('About'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              enabled: true),
                          ListTile(
                              leading: Icon(Icons.security),
                              title: Text('Privacy Policy'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              enabled: true),
                          ListTile(
                              leading: Icon(Icons.mail_outline),
                              title: Text('Contact Us'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              enabled: true),
                          ListTile(
                              leading: Icon(Icons.settings),
                              title: Text('Settings'),
                              trailing: Icon(Icons.arrow_forward_ios),
                              enabled: true,
                              onTap: () {
                                Navigator.push(context,MaterialPageRoute(builder: (context) => SettingsPage()));
                              }),
                          ListTile(
                            leading: Icon(Icons.exit_to_app),
                            title: Text('Log out'),
                            trailing: Icon(Icons.arrow_forward_ios),
                            enabled: true,
                            onTap: () async {
                              SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                              prefs.remove("username");
                              prefs.clear();
                              await facebookSignIn.logOut();

                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => LoginPage()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * .02,
                left: MediaQuery.of(context).size.width * .35,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    "http://kelvinco.ml/default_photo.png",
                  ),
                  radius: 60.0,
                ),
              )
            ])) : Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      },
    );
  }
}
