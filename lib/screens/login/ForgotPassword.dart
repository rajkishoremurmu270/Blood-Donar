import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:toast/toast.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';
  final String message =
      "An email has just been sent to you, Click the link provided to complete password reset";

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  String _email;

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  _passwordReset() async {
    try {
      _formKey.currentState.save();
      await _auth.sendPasswordResetEmail(email: _email);
      showToast(widget.message, duration: 3, gravity: Toast.BOTTOM);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return LoginPage();
        }),
      );
    } catch (e) {
      showToast(e.toString(),
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter Your Email',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
              TextFormField(
                onSaved: (newEmail) {
                  _email = newEmail;
                },
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Email',
                  icon: Icon(
                    Icons.mail,
                    color: Colors.white,
                  ),
                  errorStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  hintStyle: TextStyle(color: Colors.white),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              RaisedButton(
                child: Text('Send Email'),
                onPressed: () {
                  _passwordReset();
                  print(_email);
                },
              ),
              FlatButton(
                child: Text('Sign In'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()))
                      .then((result) {
                    Navigator.of(context).pop();
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}