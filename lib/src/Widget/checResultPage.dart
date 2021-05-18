import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:votingsystem/src/Widget/candidateListPage.dart';
import 'package:votingsystem/src/modules/api.dart';
import 'package:dio/dio.dart';

class CheckResult extends StatefulWidget {
  CheckResult({Key key, this.positionid, this.userid}) : super(key: key);
  final positionid;
  final userid;
  @override
  _CheckResult createState() => _CheckResult();
}

class _CheckResult extends State<CheckResult> {
  List data;
  bool visible = false;
  String errMessage = "Error uploading image";
  String status = '';

  Future<String> getData() async {
    var response = await http.get(Uri.parse(retrieveCandidateCheckResutl),
        headers: {"Accept": "application/json"});
    data = json.decode(response.body);

    return "success";
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  @override
  void initState() {
    final String id = widget.positionid;
    if (id != null) {
      this.getData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final positionid = widget.positionid;
    final userid = widget.userid;
    return Scaffold(
      appBar: AppBar(
        title: Text("check result"),
        backgroundColor: Color(0xff004D40),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      body: Container(
        color: Colors.green.shade50,
        margin: EdgeInsets.all(0.0),
        padding: EdgeInsets.all(0.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  height: MediaQuery.of(context).size.height - 120,
                  child: FutureBuilder(
                      future: getData(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            padding: const EdgeInsets.all(2.0),
                            itemCount: data == null ? 0 : data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var decoded = base64
                                  .decode(data[index]['candidatepicture']);
                              return Card(
                                child: Container(
                                  padding: EdgeInsets.all(4.0),
                                  child: ListTile(
                                    title: Text(
                                        '${data[index]['first_name']} ${data[index]['last_name']}',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        '${data[index]['faculty'].toString()}'),
                                    leading: ClipOval(
                                      child: Image.memory(
                                        decoded,
                                        fit: BoxFit.fill,
                                        height: 60.0,
                                        width: 60.0,
                                      ),
                                    ),
                                    trailing: InkWell(
                                      // onLongPress: () {
                                      //   voteButton(
                                      //       userid,
                                      //       '${data[index]['candidateid']}',
                                      //       '${data[index]['roleid']}');
                                      // },
                                      child: Text(
                                        "Votes: ${data[index]['voteresult']}",
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      // child: Icon(
                                      //   Icons.check_box,
                                      //   color: Colors.green,
                                      //   size: 25.0,
                                      // ),
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) => popuScreen(
                                            context,
                                            decoded: decoded,
                                            fullname:
                                                '${data[index]['first_name']} ${data[index]['last_name']}',
                                            faculty:
                                                'Faculty :${data[index]['faculty']}',
                                            position:
                                                'Position :${data[index]['rolename']}',
                                            voteresult:
                                                'Votes: ${data[index]['voteresult']}'),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget popuScreen(BuildContext context,
      {dynamic decoded,
      String fullname,
      String faculty,
      String position,
      String voteresult}) {
    // {dynamic decoded, String fullname, String faculty, String position}
    return new AlertDialog(
      // title: Text(fullname),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: 500,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              child: Image.memory(
                decoded,
                fit: BoxFit.fill,
                width: MediaQuery.of(context).size.width,
                height: 250,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fullname,
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Text(faculty),
                  Divider(),
                  Text(position),
                  Divider(
                    height: 20.0,
                  ),
                  Text(
                    voteresult,
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      actions: [
        new TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(
                  color: Colors.deepOrange, fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
