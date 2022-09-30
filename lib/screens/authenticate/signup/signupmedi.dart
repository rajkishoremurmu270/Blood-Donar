import 'package:app/loading.dart';
import 'package:app/screens/home/homemedi/medidash.dart';
import 'package:app/screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPageMedi extends StatefulWidget {
  SignupPageMedi({Key key}) : super(key: key);
  @override
  _SignupPageMediState createState() => _SignupPageMediState();
}

class _SignupPageMediState extends State<SignupPageMedi> {
  TextEditingController fullNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController phoneInputController;
  TextEditingController hospitalInputController;
  TextEditingController idNoInputController;

  @override
  initState() {
    fullNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    hospitalInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    idNoInputController = new TextEditingController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  bool _success;
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final List<String> hospitals = [
    'Ropar Civil',
    'Chandigarh Civil',
    'XYZ',
    'ABC',
    'LMN',
    'PTA',
    'VAM',
    'SAN'
  ];

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
                        'Medical Sign Up',
                        style:
                        TextStyle(color: Colors.white, fontSize: 18),
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
                      height: 5,
                    ),
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
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Email Id',
                        ),
                        controller: emailInputController,
                        keyboardType: TextInputType.emailAddress,
                        validator: emailValidator,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                      height: 5,
                    ),
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
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Select Your Hospital',
                          ),
                          items: hospitals.map((hospitalInputController) {
                            return DropdownMenuItem(
                              value: hospitalInputController,
                              child: Text('$hospitalInputController'),
                            );
                          }).toList(),
                          validator: (val) =>
                          val.isEmpty ? 'Select your hospital' : null,
                          onChanged: (val) {
                            setState(
                                    () => hospitalInputController.text = val);
                          }),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Id. No.',
                          ),
                          validator: (val) =>
                          val.isEmpty ? 'Enter your Id. No.' : null,
                          onChanged: (val) {
                            setState(
                                    () => idNoInputController.text = val);
                          }),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                        ),
                        controller: pwdInputController,
                        validator: pwdValidator,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
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
                        obscureText: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Confirm Password',
                        ),
                        controller: confirmPwdInputController,
                        validator: pwdValidator,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    InkWell(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          if (pwdInputController.text ==
                              confirmPwdInputController.text) {

                            FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                                .then((currentUser) => Firestore.instance
                                .collection("mediInfo")
                                .document(currentUser.user.email)
                                .setData({
                              "name":
                              fullNameInputController.text,
                              "phone": phoneInputController.text,
                              "hospital":
                              hospitalInputController.text,
                              "id_no": idNoInputController.text,
                            })
                                .then((result) => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          MediDash(
                                            title:
                                            fullNameInputController
                                                .text,
                                            uid: currentUser
                                                .user.email,
                                          )),
                                      (_) => false),
                              fullNameInputController.clear(),
                              emailInputController.clear(),
                              pwdInputController.clear(),
                              confirmPwdInputController
                                  .clear(),
                              phoneInputController.clear(),
                              hospitalInputController.clear(),
                              idNoInputController.clear()
                            })
                                .catchError((err) => print(err)))
                                .catchError((err) => print(err));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Error"),
                                    content: Text(
                                        "The passwords do not match"),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text("Close"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                });
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
                            'Sign Up'.toUpperCase(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Have an account ?"),
                          Text(
                            "Login",
                            style: TextStyle(color: Colors.blue[400]),
                          ),
                        ],
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
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