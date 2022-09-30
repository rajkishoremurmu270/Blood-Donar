import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Authenticate extends StatefulWidget {
  Authenticate({Key key}) : super(key: key);
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  initState() {
    FirebaseAuth.instance
        .currentUser()
        .then((currentUser) => {
      if (currentUser == null)
        {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => LoginPage()))
        }
      else
        {
          Firestore.instance
              .collection("userInfo")
              .document(currentUser.uid)
              .get()
              .then((DocumentSnapshot result) =>
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                        uid: currentUser.uid,
                      ))))
              .catchError((err) => print(err))
        }
    })
        .catchError((err) => print(err));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("Loading..."),
        ),
      ),
    );
  }
}