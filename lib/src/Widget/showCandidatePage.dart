import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:votingsystem/src/modules/api.dart';
import 'package:dio/dio.dart';

class ShowCandidateList extends StatefulWidget {
  ShowCandidateList({Key key, this.positionid, this.userid}) : super(key: key);
  final positionid;
  final userid;
  @override
  _ShowCandidateList createState() => _ShowCandidateList();
}

class _ShowCandidateList extends State<ShowCandidateList> {
  List data;
  bool visible = false;
  String errMessage = "Error uploading image";
  String status = '';

  Future<String> getData({String positionid}) async {
    var response = await http.get(
        Uri.parse(retrieveCandidateListid + '$positionid'),
        headers: {"Accept": "application/json"});
    data = json.decode(response.body);

    return "success";
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  Future voteButton(userid, candidateId, positionid) async {
    setState(() {
      visible = true;
    });

    Dio().post(vorterurl, data: {
      'voterid': userid,
      'candidateid': candidateId,
      'positionid': positionid,
      'status': 1
    }).then((result) {
      // setStatus(result.statusCode == 200 ? result.data : errMessage);
      if (result.data['message'] == "Congratulation") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text(result.data['message']),
                actions: <Widget>[
                  TextButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else if (result.data['message'] == "You can't vote twice!") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: new Text(result.data['message']),
                actions: <Widget>[
                  TextButton(
                    child: new Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      }
    }).catchError((error) {
      setStatus(error);
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
        title: Text("Candidate list"),
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
                      future: getData(positionid: positionid),
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
                                      onLongPress: () {
                                        voteButton(
                                            userid,
                                            '${data[index]['candidateid']}',
                                            '${data[index]['roleid']}');
                                      },
                                      child: Icon(
                                        Icons.how_to_vote,
                                        color: Colors.deepOrange,
                                        size: 25.0,
                                      ),
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
                                                'Position :${data[index]['rolename']}'),
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
      {dynamic decoded, String fullname, String faculty, String position}) {
    // {dynamic decoded, String fullname, String faculty, String position}
    return new AlertDialog(
      // title: Text(fullname),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
        padding: EdgeInsets.all(0.0),
        width: MediaQuery.of(context).size.width,
        height: 450,
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
                height: 200,
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
