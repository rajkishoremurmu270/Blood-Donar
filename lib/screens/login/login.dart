import 'package:app/loading.dart';
import 'package:app/screens/authenticate/signup/signup.dart';
import 'package:app/screens/authenticate/signup/signupmedi.dart';
import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/home/homemedi/medidash.dart';
import 'package:app/screens/login/ForgotPassword.dart';
import 'package:app/screens/seeker/loginseek.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String radioButtonItem = 'Medical Staff';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  //final FirebaseMessaging _fcm = FirebaseMessaging();
  String fcmToken;
  var ussr;
  bool loading = false;

  void getToken() async {
   // fcmToken = await _fcm.getToken();
   // print(fcmToken);
  }

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    getToken();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  // Group Value for Radio Button.
  int id = 1;
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
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
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'Login',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
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
                          borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextFormField(
                        controller: emailInputController,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.person,
                            color: Colors.blue[400],
                          ),
                          hintText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: 45,
                      margin: EdgeInsets.only(top: 32),
                      padding: EdgeInsets.only(
                          top: 4, left: 16, right: 16, bottom: 4),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.all(Radius.circular(50)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12, blurRadius: 5)
                          ]),
                      child: TextFormField(
                        controller: pwdInputController,
                        obscureText: true,
                        validator: pwdValidator,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: Icon(
                            Icons.vpn_key,
                            color: Colors.blue[400],
                          ),
                          hintText: 'Password',
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Radio(
                          value: 1,
                          groupValue: id,
                          activeColor: Colors.blue[400],
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'Medical Staff';
                              id = 1;
                            });
                          },
                        ),
                        Text(
                          'Medical Staff',
                          style: new TextStyle(fontSize: 17.0),
                        ),
                        Radio(
                          value: 2,
                          groupValue: id,
                          activeColor: Colors.blue[400],
                          onChanged: (val) {
                            setState(() {
                              radioButtonItem = 'User';
                              id = 2;
                            });
                          },
                        ),
                        Text(
                          'User',
                          style: new TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ForgotPassword()));
                      },
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding:
                          const EdgeInsets.only(top: 16, right: 32),
                          child: Text(
                            'Forgot Password ?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () async {
                        if (radioButtonItem == 'Medical Staff') {
                          if (_formKey.currentState.validate()) {

                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance
                                .collection("mediInfo")
                                .document(currentUser.user.uid)
                                .get()
                                .then((DocumentSnapshot result) =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MediDash(
                                              uid: currentUser
                                                  .user.email,
                                            ))))
                                .catchError((err) =>
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(err.toString()),
                                ))))
                                .catchError((err) =>
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(err.toString()),
                                )));
                          }
                        } else {
                          if (_formKey.currentState.validate()) {

                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance
                                .collection("userInfo")
                                .document(currentUser.user.email)
                                .get()
                                .then((DocumentSnapshot result) =>
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomePage(
                                              /*title:
                                                          result.data['name'],*/
                                              uid: currentUser
                                                  .user.email,
                                            ))))
                                .catchError((err) =>
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(err.toString()),
                                ))))
                                .catchError((err) =>
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(err.toString()),
                                )));
                            Firestore.instance
                                .collection("userInfo")
                                .document(emailInputController.text)
                                .updateData({'token': fcmToken});
                          }
                        }
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
                            'Login'.toUpperCase(),
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
            SizedBox(
              height: 15,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Looking for Donor? "),
                  Text(
                    "Guest Log In",
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginSeek()));
              },
            ),
            SizedBox(
              height: 15,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account? "),
                  Text(
                    "Sign Up",
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ],
              ),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  // set up the list options
  Widget optionOne = SimpleDialogOption(
    child: const Text('Medical Staff'),
    onPressed: () {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => SignupPageMedi()))
          .then((result) {
        Navigator.of(context).pop();
      });
    },
  );
  Widget optionTwo = SimpleDialogOption(
    child: const Text('User'),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignupPage()))
          .then((result) {
        Navigator.of(context).pop();
      });
    },
  );

  // set up the SimpleDialog
  SimpleDialog dialog = SimpleDialog(
    title: const Text('Who are you?'),
    children: <Widget>[
      optionOne,
      optionTwo,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return dialog;
    },
  );
}