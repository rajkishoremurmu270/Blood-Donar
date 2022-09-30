import 'package:app/screens/seeker/enter_otp.dart';
import 'package:flutter/material.dart';

class LoginSeek extends StatefulWidget {
  @override
  _LoginSeekState createState() => _LoginSeekState();
}

class _LoginSeekState extends State<LoginSeek> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    colors: [Colors.blue, Colors.blue],
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
                      padding: const EdgeInsets.only(bottom: 32, right: 32),
                      child: Text(
                        'Seeker   Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
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
              child: Column(
                children: <Widget>[
                  // Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: 45,
                    padding:
                    EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      //maxLength: 10,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.call,
                          color: Colors.blue,
                        ),
                        hintText: '  phone number',
                        prefix: Text('+91'),
                      ),

                      keyboardType: TextInputType.number,
                      controller: _controller,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EnterOTP(_controller.text)));
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.blue,
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Login'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}