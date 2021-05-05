import "package:flutter/material.dart";
import 'package:votingsystem/src/Widget/camara.dart';

class CandidatePageSetting extends StatefulWidget {
  CandidatePageSetting({Key key}) : super(key: key);

  @override
  _CandidatePageSettingState createState() => _CandidatePageSettingState();
}

class _CandidatePageSettingState extends State<CandidatePageSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        backgroundColor: Color(0xff004D40),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.all(0.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          )),
    );
  }
}
