import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
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


class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
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