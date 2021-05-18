import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:votingsystem/src/Widget/checResultPage.dart';
import 'package:votingsystem/src/Widget/registerCandidatePage.dart';
import 'package:votingsystem/src/Widget/showCandidatePage.dart';
import 'package:votingsystem/src/auth/loginPage.dart';
import 'package:votingsystem/src/homePage.dart';
import 'package:votingsystem/src/modules/api.dart';

class StartPage extends StatefulWidget {
  StartPage({Key key, this.userid}) : super(key: key);
  final userid;

  @override
  _StartPage createState() => _StartPage();
}

class _StartPage extends State<StartPage> {
  List data;

  Future<String> getData() async {
    var response = await http.get(Uri.parse(retrieveCandidateList),
        headers: {"Accept": "application/json"});

    // this.setState(() {
    data = json.decode(response.body)[1];
    // });

    return "success";
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    final userid = widget.userid;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(""),
        backgroundColor: Color(0xff004D40),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0 : 0.0,
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.white,
        ),
        child: new Drawer(
          child: new ListView(
            padding: const EdgeInsets.all(0.0),
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text("Online Voting System"),
                accountEmail: new Text("nankim45@gmail.com"),
                decoration: BoxDecoration(
                  color: const Color(0xff004D40),
                ),
                currentAccountPicture: new CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
              ),
              new ListTile(
                title: new Text('Become a candidate',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                trailing: new Icon(Icons.app_registration_rounded),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CandidateRegisterPage()));
                },
              ),
              new ListTile(
                title: new Text('Notification',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                trailing: new Icon(Icons.notification_add),
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CheckResult()))
                },
              ),
              new ListTile(
                title: new Text('Logout',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
                trailing: new Icon(Icons.logout),
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()))
                },
              )
            ],
          ),
        ),
      ),
      body: new Center(
        child: Container(
          color: Colors.green.shade50,
          margin: EdgeInsets.all(0.0),
          padding: EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      "Differents Candidate positions",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 30.0,
                          fontWeight: FontWeight.w300),
                    ),
                    subtitle: Text(
                      "You have to pick one candidate postion at once, In order to see your preferred candidate to vote for!.",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )),
              SizedBox(
                height: 30.0,
              ),
              Container(
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(0.0),
                  child: FutureBuilder(
                    future: getData(),
                    // ignore: missing_return
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: data == null ? 0 : data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                  data[index]["name"],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                    "The president of campus is the one who's in of students activities."),
                                leading:
                                    Icon(Icons.star, color: Colors.blueAccent),
                                trailing: Icon(Icons.arrow_forward_ios,
                                    color: Colors.deepOrange),
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ShowCandidateList(
                                                  positionid: data[index]["id"]
                                                      .toString(),
                                                  userid: userid)));
                                },
                              ),
                            );
                          },
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

// // Append to List

// // ignore: must_be_immutable
// class CandidateRoles extends StatelessWidget {
//   final List<ModuleCandidateRoles> candidateroles;
//   String errMessage;
//   String status = '';
//   CandidateRoles({Key key, this.candidateroles}) : super(key: key);

//   setStatus(String message) {
//     setState(() {
//       status = message;
//     });
//   }

//   gotoButton(roleid) {
//     Dio().post(getcandidateroles, data: {'roleid': roleid}).then((result) {
//       setStatus(result.statusCode == 200 ? result.data : errMessage);
//     }).catchError((error) {
//       setStatus(error);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//         itemCount: candidateroles.length == null ? 1 : candidateroles.length,
//         itemBuilder: (context, snapshot) {
//           return Card(
//             color: Colors.lightGreen.shade50,
//             margin: EdgeInsets.only(right: 8.0, left: 8.0),
//             child: InkWell(
//               child: Text('Test'),
//             ),
//           );
//         });
//   }
// }

// void setState(Null Function() param0) {}

// //  Get deffrent options

// class ModuleCandidateRoles {
//   int id;
//   String roles;

//   ModuleCandidateRoles({this.id, this.roles});
//   factory ModuleCandidateRoles.fromJson(Map<String, dynamic> json) {
//     return ModuleCandidateRoles(
//       id: json['id'],
//       roles: json['name'],
//     );
//   }
// }

// Future<List<ModuleCandidateRoles>> fetchCandidateRoles(
//     http.Client client) async {
//   final response = await client.get(Uri.parse(retrieveCandidateList));
//   return compute(parseCandidateRoles, response.body);
// }

// List<ModuleCandidateRoles> parseCandidateRoles(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   // print('SDDDD ??$parsed');

//   return parsed
//       .map<ModuleCandidateRoles>((json) => ModuleCandidateRoles.fromJson(json))
//       .toList();
// }
