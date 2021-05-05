import "package:flutter/material.dart";

class CandidateListPage extends StatefulWidget {
  CandidateListPage({Key key, this.title}) : super(key: key);

  final title;
  @override
  _CandidateListPageState createState() => _CandidateListPageState();
}

class _CandidateListPageState extends State<CandidateListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of candidate"),
        backgroundColor: Color(0xff004D40),
      ),
      body: Text('List view'),
    );
  }
}
