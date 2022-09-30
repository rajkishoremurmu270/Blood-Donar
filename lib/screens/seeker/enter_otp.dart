import 'package:app/screens/seeker/homeseek.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class EnterOTP extends StatefulWidget {
  final String phone;
  EnterOTP(this.phone);
  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text('OTP Verification'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Text(
                'Verify +91-${widget.phone}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Pinput(
              //fieldsCount: 6,
             // textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
             // eachFieldWidth: 40.0,
             // eachFieldHeight: 55.0,
              focusNode: _pinPutFocusNode,
              controller: _pinPutController,
              //submittedFieldDecoration: pinPutDecoration,
              //selectedFieldDecoration: pinPutDecoration,
              //followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.fade,
              onCompleted: (pin) async {
                try {
                  await FirebaseAuth.instance
                      .signInWithCredential(PhoneAuthProvider.getCredential(
                      verificationId: _verificationCode, smsCode: pin))
                      .then((value) async {
                    if (value.user != null) {
                      final FirebaseUser user =
                      await FirebaseAuth.instance.currentUser();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeSeek(user: user)),
                              (route) => false);
                    }
                  });
                } catch (e) {
                  FocusScope.of(context).unfocus();
                  _scaffoldkey.currentState
                      .showSnackBar(SnackBar(content: Text('Wrong OTP')));
                }
              },
            ),
          ),
          TextButton(
            onPressed: () async {
              _verifyPhone();
            },
            child: Text('Resend OTP'),
          ),
          //OtpTimer(radius: 10, duration: 30, timeTextSize: 16),
        ],
      ),
    );
  }

  _verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (AuthCredential credential) async {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeSeek(
                        user: value.user,
                      )),
                      (route) => false);
            }
          });
        },
        verificationFailed: (AuthException e) {
          print(e.message);
        },
        codeSent: (String verficationID, [int resendToken]) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 30));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }
}
