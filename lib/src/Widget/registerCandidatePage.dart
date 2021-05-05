import 'package:flutter/material.dart';
import 'package:votingsystem/src/Widget/camara.dart';
import 'package:votingsystem/src/Widget/candidatePageSetting.dart';

class CandidateRegisterPage extends StatefulWidget {
  CandidateRegisterPage({Key key}) : super(key: key);

  @override
  _CandidateRegisterPage createState() => _CandidateRegisterPage();
}

class _CandidateRegisterPage extends State<CandidateRegisterPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
        backgroundColor: Color(0xff004D40),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Become a canditate..."),
          Padding(
            padding: EdgeInsets.all(20),
            child: _formInput(context),
          )
        ],
      ),
    );
  }

  Widget _formInput(context) {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            TextFormField(
              decoration: new InputDecoration(
                labelText: "First name ",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter name";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: new InputDecoration(
                labelText: "Last name",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter last name";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: new InputDecoration(
                labelText: "Email",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter email";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: new InputDecoration(
                labelText: "Faculty",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please specify the faculty";
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: new InputDecoration(
                labelText: "In take",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please specify the faculty";
                }
                return null;
              },
            ),
            SizedBox(height: 40),
            _registerButton(context),
            SizedBox(height: 80),
          ],
        ));
  }

  Widget _registerButton(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TakePicture()));
      },
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
