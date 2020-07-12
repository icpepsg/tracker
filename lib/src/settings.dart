import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/common/Constants.dart';
import 'package:tracker/src/customwidget/ImageContainer.dart';
//import 'package:tracker/src/service/theme_service.dart';

/*
 Author : kelvin Co
 */

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool isSwitched = false;
  bool isDarkOn = false;
  @override
  void initState() {
    super.initState();
    getDarkMode();
  }
  void getDarkMode() async{
    isDarkOn = await _getTheme();
  }

  Future<bool> _getTheme() async {
    final SharedPreferences prefs = await _prefs;
    isDarkOn = prefs.getBool('isDarkMode');
    return prefs.getBool('isDarkMode');
  }

  Future<void> _setTheme(bool theme) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool("isDarkMode", theme);
  }

  @override
  Widget build(BuildContext context) {
    //final themeBloc = BlocProvider.of<ThemeBloc>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Container(
              height: 45,
              child: ImageContainer(assetLocation: Constants.IMG_ICPEP),
            ),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'ICpEP Singapore',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green[600]),
                )),
          ],
        ),
      ),
      body: FutureBuilder(
        future: _getTheme(),
        builder: (context,snapshot){
          return (isDarkOn!=null) ? Column(
            children: [
              ListTile(
                leading: Icon(Icons.data_usage),
                title: Text('Enable Background Activity'),
                trailing: Switch(
                  value: isSwitched,
                  onChanged: (value){
                    setState(() {
                      isSwitched=value;
                      print(isSwitched);

                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ),

              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Enable Dark Mode'),
                trailing: Switch(
                  value: isDarkOn,
                  onChanged: (value){
                    setState(() {
                      isDarkOn=value;
                      print(isDarkOn);
                      //themeBloc.add(ThemeEvent.toggle);
                      //context.bloc<ThemeBloc>().add(ThemeEvent.toggle);
                      _setTheme(value);
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              )
            ],
          ) : Scaffold(body: Center(child: CircularProgressIndicator(),),);
        },
      )
    );
  } // end build

}
