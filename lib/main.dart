import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:votingsystem/src/Widget/camara.dart';
import 'package:votingsystem/src/Widget/candidateListPage.dart';
import 'package:votingsystem/src/Widget/registerCandidatePage.dart';
import 'package:votingsystem/src/homePage.dart';
import 'package:votingsystem/src/strartPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final cameras;

  // This widget is the root of your application.
  MyApp({this.cameras}) : super();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
        title: 'Online Voting System',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: GoogleFonts.latoTextTheme(textTheme).copyWith(
            bodyText1: GoogleFonts.montserrat(textStyle: textTheme.bodyText1),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: HomePage());
   
  }
}

