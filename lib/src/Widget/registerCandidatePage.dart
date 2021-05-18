import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:votingsystem/src/Widget/camara.dart';
import 'package:votingsystem/src/Widget/candidatePageSetting.dart';
import 'package:votingsystem/src/modules/api.dart';
import 'package:dio/dio.dart';

class CandidateRegisterPage extends StatefulWidget {
  CandidateRegisterPage({Key key}) : super(key: key);

  @override
  _CandidateRegisterPage createState() => _CandidateRegisterPage();
}

class _CandidateRegisterPage extends State<CandidateRegisterPage> {
  // For CircularProgressIndicator
  bool visible = false;
  // String dropdownValue = 'One';
  // Getting value from textField widget

  String emailtext = "";
  var dio = Dio();
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final inTakeController = TextEditingController();

  String _dropdownError;
  String _selectedItem;
  Response response;

  // Retrieve candidate role
  ModuleRetrieveCandidateRoles _getitems;
  List<ModuleRetrieveCandidateRoles> _moduleRetrieveCandidateRoles;

  // var dio = Dio();
  // Response response = await dio.get(retrieveCandidateRoles)

  @override
  void initState() {
    _moduleRetrieveCandidateRoles = [];
    getItemRoles();
  }

  getItemRoles() async {
    response = await dio.get(retrieveCandidateRoles);
    return response.data;
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future regCandidate() async {
    // Showing circularProgressIndicator.
    setState(() {
      visible = true;
    });

    String email = emailController.text;
    String name = nameController.text;
    String lastName = lastNameController.text;
    // String faculty = facultyController.text;
    String intake = inTakeController.text;

    final form = _formKey.currentState;
    form.save();

    if (_selectedItem == null) {
      setState(() => _dropdownError = "Please select an option!");
      // _isValid = false;
    }

    // Call the api
    // var url = Uri.parse(candidateReg);

    var data = {
      'email': email,
      'firstname': name,
      'lastname': lastName,
      'intake': intake,
      'roles': _selectedItem
    };

    var response = await Dio().post(candidateReg, data: data);

    if (response.data['message'] == "Successfuly registered!") {
      setState(() {
        visible = false;
      });

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(response.data['message']),
              actions: <Widget>[
                TextButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TakePicture()));
                  },
                )
              ],
            );
          });
    } else {
      setState(() {
        visible = false;
      });

      // Showing alert Dialog with Response Json Message.
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text(response.data['error']),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        backgroundColor: Color(0xff004D40),
      ),
      body: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Become a canditate..."),
          Padding(
            padding: EdgeInsets.all(20),
            child: _formInput(context),
          )
        ],
      )),
    );
  }

  Widget _formInput(context) {
    return Form(
        key: _formKey,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 60.0,
                child: Center(
                  child: TextFormField(
                    controller: nameController,
                    autocorrect: true,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        )),
                    validator: (val) =>
                        val.isNotEmpty ? null : "Name must not be empty!.",
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                alignment: Alignment.centerLeft,
                height: 60.0,
                child: Center(
                  child: TextFormField(
                    controller: lastNameController,
                    autocorrect: true,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                        labelText: "Last name",
                        prefixIcon: Icon(
                          Icons.format_list_numbered,
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        )),
                    validator: (val) => val.isNotEmpty
                        ? null
                        : "Last name field must not be empty!",
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Container(
                alignment: Alignment.centerLeft,
                height: 60.0,
                child: Center(
                  child: TextFormField(
                    controller: emailController,
                    autocorrect: true,
                    cursorColor: Colors.black,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(
                          Icons.email,
                          color: Colors.black54,
                        ),
                        border: OutlineInputBorder(),
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                        labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        )),
                    validator: (val) => val.isNotEmpty
                        ? null
                        : "Email field must not be empty!.",
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedItem,
                  isExpanded: true,
                  hint: Text("Select roles", maxLines: 3),
                  items:
                      ["President", "Minister", "Deputy"].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: new Text(
                        value ?? "",
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedItem = value;
                      _dropdownError = null;
                    });
                  },
                ),
              ),
              _dropdownError == null
                  ? SizedBox.shrink()
                  : Text(
                      _dropdownError ?? "",
                      style: TextStyle(color: Colors.red),
                    ),
              SizedBox(height: 30.0),
              Container(
                alignment: Alignment.centerLeft,
                height: 60.0,
                child: TextFormField(
                  controller: inTakeController,
                  autocorrect: true,
                  cursorColor: Colors.black,
                  // obscureText: true,
                  style: TextStyle(color: Colors.black54),
                  decoration: new InputDecoration(
                      labelText: "In take",
                      prefixIcon: Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(),
                      fillColor: Color(0xfff3f3f4),
                      filled: true,
                      labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
                      )),
                  validator: (val) => val.isNotEmpty
                      ? null
                      : "You have to fill in take field!.",
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              _registerButton(context),
              SizedBox(height: 80.0),
              Visibility(
                visible: visible,
                child: Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: CircularProgressIndicator(),
                ),
              ),
            ]));
  }

  Widget _registerButton(context) {
    return InkWell(
      onTap: regCandidate,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff004D40), Color(0xff004D40)])),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}

// Retrieve candidate roles

class ModuleRetrieveCandidateRoles {
  int roleid;
  String rolename;

  ModuleRetrieveCandidateRoles({this.roleid, this.rolename});

  factory ModuleRetrieveCandidateRoles.fromJson(Map<String, dynamic> json) {
    return ModuleRetrieveCandidateRoles(
        roleid: json['id'], rolename: json['name'].toString());
  }

  Map<String, dynamic> toMap() => {'id': roleid, 'name': rolename};
}

List<ModuleRetrieveCandidateRoles> moduleRetrieveCandidateRolesFromJson(
        String str) =>
    List<ModuleRetrieveCandidateRoles>.from(json
        .decode(str)
        .map((x) => ModuleRetrieveCandidateRoles.fromJson((x))));

Future<List<ModuleRetrieveCandidateRoles>> getCanditeRoles() async {
  Response response;
  var dio = Dio();
  response = await dio.get(retrieveCandidateRoles);
  return moduleRetrieveCandidateRolesFromJson(response.data);
}
