import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:votingsystem/src/Widget/menuPage.dart';
import 'package:votingsystem/src/auth/signupPage.dart';
import 'package:votingsystem/src/modules/api.dart';
import 'package:dio/dio.dart';
import 'package:votingsystem/src/strartPage.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // For CircularProgressIndicator
  bool visible = false;
  // Getting value from textField widget
  String emailtext = "";
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future userLogin() async {
    // Showing circularProgressIndicator.
    setState(() {
      visible = true;
    });

    String email = emailController.text;
    String password = passwordController.text;

    final form = _formKey.currentState;
    form.save();

    // Call the api

    if (form.validate()) {
      var data = {'email': email, 'password': password};

      var response = await Dio().post(loginUserUrl, data: data);

      if (response.data['message'] == "access_connexion_allowed...") {
        setState(() {
          visible = false;
        });

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    StartPage(userid: response.data['access'].toString())));
      } else {
        // If Email or Password didn't matched.
        // Hidding the CircularProgressIndicator.
        // setState(() {
        //   visible = false;
        // });

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
                  _title(),
                  SizedBox(height: 50),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
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
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  _loginButton(),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: Text('Forgot Password ?',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  _divider(),
                  _facebookButton(),
                  SizedBox(height: height * .055),
                  _createAccountLabel(),
                ],
              ),
            ),
          ),
          Positioned(top: 40, left: 0, child: _backButton()),
        ],
      ),
    ));
  }

  Widget _backButton() {
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

  // Widget _inputField(String title, {bool isPassword = false}) {
  //   return Container(
  //       margin: EdgeInsets.symmetric(vertical: 10),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           Text(
  //             title,
  //             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
  //           ),
  //           SizedBox(
  //             height: 10,
  //           ),
  //           TextField(
  //               obscureText: isPassword,
  //               decoration: InputDecoration(
  //                 fillColor: Color(0xfff3f3f4),
  //                 filled: true,
  //                 border: OutlineInputBorder(),
  //                 counterText: '0 characters',
  //               ))
  //         ],
  //       ));
  // }

  Widget _loginButton() {
    return InkWell(
      onTap: userLogin,
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
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _dividers() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _facebookButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff1959a9),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: Text('f',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w400)),
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2872ba),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(5),
                    topRight: Radius.circular(5)),
              ),
              alignment: Alignment.center,
              child: InkWell(
                child: Text(
                  'Log in with Facebook',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
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

  // Widget _emailPasswordWidget() {
  //   return Column(
  //     children: <Widget>[
  //       _inputField("Email"),
  //       _inputField("Password", isPassword: true),
  //     ],
  //   );
  // }
}
