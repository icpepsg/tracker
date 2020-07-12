import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tracker/src/SplashScreen.dart';
import 'package:tracker/src/service/bloc_delegate.dart';
import 'package:tracker/src/service/theme_service.dart';
/*
 Author : kelvin Co
 */
//void main() => runApp(MyApp());
void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp>{
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool isDarkOn = false;
  @override
  void initState() {
    super.initState();
  }

  void getDarkMode() async{
    isDarkOn = await _getTheme();
    print('isDarkOn : ' +isDarkOn.toString());
    isDarkOn ? ThemeData.light() : ThemeData.dark() ;
  }

  Future<bool> _getTheme() async {
    final SharedPreferences prefs = await _prefs;
    isDarkOn = prefs.getBool('isDarkMode');
    return prefs.getBool('isDarkMode');
  }



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
   // final textTheme = Theme.of(context).textTheme;
    return BlocProvider(
          create: (_) => ThemeBloc(),
          child: BlocBuilder<ThemeBloc, ThemeData>(
            builder: (_,theme){
              return MaterialApp(
                title: 'ICpEP-Community Tracker',
                theme: theme,
                debugShowCheckedModeBanner: false,
                home: SplashScreen(),
              );
            },
          )
    );



  }
}