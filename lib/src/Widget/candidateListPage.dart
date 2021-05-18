import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:votingsystem/src/modules/api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class CandidateListPage extends StatefulWidget {
  CandidateListPage({this.userid, Key key, this.title}) : super(key: key);

  final title;
  final userid;
  @override
  _CandidateListPageState createState() => _CandidateListPageState();
}

class _CandidateListPageState extends State<CandidateListPage> {
  @override
  Widget build(BuildContext context) {
    final userid = widget.userid;
    return Scaffold(
      appBar: AppBar(
        title: Text("List of candidate"),
        backgroundColor: Color(0xff004D40),
      ),
      body: FutureBuilder<List<ModuleRetrieveCandidateList>>(
        future: fetchCandidates(http.Client(), userid),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          print(snapshot.hasData);
          return snapshot.hasData
              ? PhotosList(candidates: snapshot.data, userid: userid)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PhotosList extends StatelessWidget {
  final List<ModuleRetrieveCandidateList> candidates;
  final userid;                                                                               
  String errMessage = "Error uploading image";
  String status = '';
  PhotosList({Key key, this.candidates, this.userid}) : super(key: key);

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  voteButton(voterid, candidateid) {
    Dio().post(vorterurl, data: {
      'voterid': voterid,
      'candidateid': candidateid,
      'status': 1
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.data : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    final voterid = '';
    // final userid = userid;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: candidates.length == null ? 1 : candidates.length,
      itemBuilder: (context, index) {
        var decoded = base64.decode(candidates[index].candidatepicture);
        return Card(
          color: Colors.lightGreen.shade50,
          margin: EdgeInsets.only(right: 8.0, left: 8.0),
          child: InkWell(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  child: Stack(
                    children: [
                      Image.memory(
                        decoded,
                        fit: BoxFit.cover,
                        height: 250,
                        width: MediaQuery.of(context).size.height,
                      ),
                      // candidates[index].voterstatus == 1
                      //     ? Positioned(
                      //         top: 0.0,
                      //         right: 0.0,
                      //         child: FractionalTranslation(
                      //           translation: Offset(0.3, -0.3),
                      //           child: CircleAvatar(
                      //             radius: 24.0,
                      //             backgroundColor: Colors.blue,
                      //             child: Icon(
                      //               Icons.star,
                      //               size: 24.0,
                      //               color: Colors.white,
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     : Text('')
                    ],
                  ),
                ),
                Divider(),
                Container(
                  margin: EdgeInsets.only(bottom: 10.0),
                  // child: Text(
                  //   "${candidates[index].firstname}",
                  //   textAlign: TextAlign.center,
                  //   style: TextStyle(
                  //     fontSize: 20.0,
                  //   ),
                  // ),
                  child: ListTile(
                    leading: Icon(
                      Icons.person_rounded,
                      color: Colors.blue,
                    ),
                    title: Text(
                      '${candidates[index].firstname} ${candidates[index].lastname}',
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    subtitle: Text('Run for : ${candidates[index].roles}',
                        style: TextStyle(
                          fontSize: 20.0,
                        )),
                    onTap: () {
                      voteButton(userid, candidates[index].candidateid);
                    },
                    // trailing: Icon(
                    //   Icons.where_to_vote,
                    //   color: candidates[index].voterstatus == 1
                    //       ? Colors.blue
                    //       : Colors.grey,
                    // ),
                  ),
                ),
                Divider(
                  height: 20.0,
                )
              ],
            ),
            // onTap: () {},
          ),
        );
      },
    );
  }

  void setState(Null Function() param0) {}
}

class SizeBox {}

// Retrieve Student List

class ModuleRetrieveCandidateList {
  int candidateid;
  String candidatepicture;
  String faculty;
  String firstname;
  String imagename;
  String lastname;
  String roles;
  String roleid;
  String yearofstudy;
  int voterstatus;

  ModuleRetrieveCandidateList(
      {this.candidateid,
      this.candidatepicture,
      this.faculty,
      this.firstname,
      this.imagename,
      this.lastname,
      this.roles,
      this.roleid,
      this.voterstatus,
      this.yearofstudy});

  factory ModuleRetrieveCandidateList.fromJson(Map<String, dynamic> json) {
    return ModuleRetrieveCandidateList(
        candidateid: json['candidateid'],
        candidatepicture: json['candidatepicture'],
        faculty: json['faculty'],
        firstname: json['first_name'],
        imagename: json['imagename'],
        lastname: json['last_name'],
        roles: json['roles'],
        roleid: json['role_id'],
        voterstatus: json['voterstatus'],
        yearofstudy: json['year_of_study']);
  }

  // Map<String, dynamic> toMap() => {
  //       candidateid: 'candidateid',
  //       candidatepicture: 'candidatepicture',
  //       faculty: 'faculty',
  //       firstname: 'first_name',
  //       imagename: 'imagename',
  //       lastname: 'last_name',
  //       roles: 'roles',
  //       yearofstudy: 'year_of_study'
  //     };
}

Future<List<ModuleRetrieveCandidateList>> fetchCandidates(
    http.Client client, dynamic userid) async {
  final response =
      await client.get(Uri.parse(retrieveCandidateList + '$userid'));
  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseCandidates, response.body);
}

List<ModuleRetrieveCandidateList> parseCandidates(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed
      .map<ModuleRetrieveCandidateList>(
          (json) => ModuleRetrieveCandidateList.fromJson(json))
      .toList();
}





// List<ModuleRetrieveCandidateList> moduleRetrieveCandidateListFromJson(
//         String str) =>
//     List<ModuleRetrieveCandidateList>.from(
//         json.decode(str).map((x) => ModuleRetrieveCandidateList.fromJson((x))));

// Future getCanditeList() async {
//   Uri()
//   var response = await http.get());
//   if (response.statusCode == 200) {
//     final items = json.decode(response.body);
//     print(items);
//     // return moduleRetrieveCandidateListFromJson;
//   } else {
//     throw Exception('Failed to load data.');
//   }
// }

// Future<List<ModuleRetrieveCandidateList>> getCanditeList() async {
//   Response response;
//   var dio = Dio();
//   response = await dio.get(retrieveCandidateList);
//   return moduleRetrieveCandidateListFromJson(response.data);
// }
