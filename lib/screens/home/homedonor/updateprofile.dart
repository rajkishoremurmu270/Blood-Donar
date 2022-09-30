import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:collection';
import 'package:toast/toast.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class UpdatePage extends StatefulWidget {
  final String uid;
  UpdatePage({Key key, this.uid}) : super(key: key);

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  TextEditingController fullNameInputController;
  TextEditingController phoneInputController;
  TextEditingController ageInputController;
  String age;
  String name;
  String phone;
  //final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  initState() {
    fullNameInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    ageInputController = new TextEditingController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    database();
    super.initState();
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var variable, variablee;
  Future<void> showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  void database() async {
    variable = await Firestore.instance
        .collection('userInfo')
        .document(widget.uid)
        .get();

    setState(() {
      variablee = variable;
    });
  }

  void updateage(String text) {
    age = text;
  }

  @override
  Widget build(BuildContext context) {
    if (variable != null) {
      fullNameInputController.text = variable.data['name'];
      ageInputController.text = '${variable.data['age']}';
      phoneInputController.text = variable.data['phone'];
      return Scaffold(
        appBar: AppBar(
          title: Text("Update Profile Info"),
          backgroundColor: Colors.blue[400],
          centerTitle: true,
        ),
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 62),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Full Name',
                          ),
                          controller: fullNameInputController,
                          validator: (value) {
                            if (value.length < 3) {
                              return "Please enter a valid name.";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.call,
                              color: Colors.blue,
                            ),
                            hintText: '  phone number',
                            prefix: Text('+91'),
                          ),
                          validator: (val) =>
                          val.isEmpty ? 'Enter mobile number' : null,
                          controller: phoneInputController,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: 45,
                        padding: EdgeInsets.only(
                            top: 4, left: 16, right: 16, bottom: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 5)
                            ]),
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Age',
                          ),
                          controller: ageInputController,
                          validator: (value) {
                            if (int.parse(value) < 18) {
                              return "You are below 18";
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () async {
                          print(age);
                          await Firestore.instance
                              .collection("userInfo")
                              .document(widget.uid)
                              .updateData({
                            "name": fullNameInputController.text,
                            "phone": phoneInputController.text,
                            "age": int.parse(ageInputController.text),
                          });
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    //title: variable.data['name'],
                                    uid: this.widget.uid,
                                  ))).then((result) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue[400],
                                  Colors.blue[400],
                                ],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'Update'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else
      return Scaffold(
        body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                width: 600,
                height: MediaQuery.of(context).size.height / 5,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.blue[400], Colors.blue[400]],
                    ),
                    borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(90))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32, right: 32),
                        child: Text(
                          'Update Profile Info',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 62),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage(
                                    //title: variable.data['name'],
                                    uid: this.widget.uid,
                                  ))).then((result) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width / 1.2,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue[400],
                                  Colors.blue[400],
                                ],
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(50))),
                          child: Center(
                            child: Text(
                              'update'.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}