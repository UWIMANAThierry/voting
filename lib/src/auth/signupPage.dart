import 'dart:convert';
import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votingsystem/src/auth/loginPage.dart';
import 'package:votingsystem/src/modules/api.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // For CircularProgressIndicator
  bool visible = false;
  String _selectedItem;
  String _dropdownError;
  // Getting value from textField widget
  String emailtext = "";
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final regnumberController = TextEditingController();
  final passwordController = TextEditingController();
  final reppeatPasswordController = TextEditingController(text: '');

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future userSignup() async {
    // Showing circularProgressIndicator.
    setState(() {
      visible = true;
    });

    String email = emailController.text;
    String username = usernameController.text;
    String regnumber = regnumberController.text;
    String password = passwordController.text;
    String reppearpassword = reppeatPasswordController.text;

    final form = _formKey.currentState;
    form.save();

    // Call the api
    var url = Uri.parse(registerUserUrl);

    if (password == reppearpassword && email != '') {
      if (_selectedItem == null) {
        setState(() => _dropdownError = "Please select an option!");
        // _isValid = false;
      }
      var data = {
        'email': email,
        'username': username,
        'regnumber': regnumber,
        'faculty': _selectedItem,
        'passwordhash': password,
        'reppeatpassword': reppearpassword,
        'is_public': true,
        'is_admin': false
      };

      var response = await Dio().post(registerUserUrl, data: data);

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
                          MaterialPageRoute(builder: (context) => LoginPage()));
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
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text("The password didn't match..."),
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(context),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
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
                                    controller: usernameController,
                                    autocorrect: true,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.black),
                                    decoration: new InputDecoration(
                                        labelText: "Username",
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
                                    validator: (val) => val.isNotEmpty
                                        ? null
                                        : "Password field must not remain empty!.",
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 60.0,
                                child: Center(
                                  child: TextFormField(
                                    controller: regnumberController,
                                    autocorrect: true,
                                    cursorColor: Colors.black,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(color: Colors.black),
                                    decoration: new InputDecoration(
                                        labelText: "Reg. number",
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
                                        : "Reg number Field must not remain empty",
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedItem,
                                  isExpanded: true,
                                  hint: Text("Select roles", maxLines: 3),
                                  items: ["BBM", "BIT", "CE", "TTM", "CIS"]
                                      .map((String value) {
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
                                        : "Email field must not remain empty!.",
                                  ),
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 60.0,
                                child: TextFormField(
                                  controller: passwordController,
                                  autocorrect: true,
                                  cursorColor: Colors.black,
                                  obscureText: true,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.black54),
                                  decoration: new InputDecoration(
                                      labelText: "*********",
                                      prefixIcon: Icon(
                                        Icons.security,
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
                                      : "You have to the password!.",
                                ),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                alignment: Alignment.centerLeft,
                                height: 60.0,
                                child: TextFormField(
                                  controller: reppeatPasswordController,
                                  autocorrect: true,
                                  cursorColor: Colors.black,
                                  obscureText: true,
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(color: Colors.black54),
                                  decoration: new InputDecoration(
                                      labelText: "*********",
                                      prefixIcon: Icon(
                                        Icons.security,
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
                                      : "You have to the password!.",
                                ),
                              ),
                              SizedBox(
                                height: 80.0,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
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
                                          colors: [
                                            Color(0xff004D40),
                                            Color(0xff004D40)
                                          ])),
                                  child: GestureDetector(
                                    onTap: userSignup,
                                    child: Center(
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 20.0),
                              Visibility(
                                visible: visible,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            ])),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: height * .10),
                    _loginAccountLabel(context),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _title(context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'Voting',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xFF66BB6A),
          ),
          children: [
            TextSpan(
              text: ' System',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
          ]),
    );
  }

  Widget _loginAccountLabel(context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          padding: EdgeInsets.all(15),
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Already have an account ?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Login',
                style: TextStyle(
                    color: Color(0xfff79c4f),
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ));
  }

  Widget _backButton(context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }
}
