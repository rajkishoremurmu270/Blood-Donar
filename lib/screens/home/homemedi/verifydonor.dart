import 'package:app/screens/home/homemedi/medidash.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/screens/service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyDonor extends StatefulWidget {
  VerifyDonor({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;
  @override
  _VerifyDonorState createState() => _VerifyDonorState();
}

class _VerifyDonorState extends State<VerifyDonor> {
  TextEditingController fullNameInputController;
  TextEditingController emailInputController;
  TextEditingController bloodgroupInputController;
  DocumentSnapshot variable, variablee;
  void database() async {
    variable = await Firestore.instance
        .collection('mediInfo')
        .document(widget.uid)
        .get();
    setState(() {
      variablee = variable;
    });
  }

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final List<String> bloodgrps = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];

  @override
  void initState() {
    database();
    fullNameInputController = new TextEditingController();
    bloodgroupInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    SystemChrome.setEnabledSystemUIOverlays([]);

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

  @override
  Widget build(BuildContext context) {
    if (variable != null) {
      return Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget> [
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue[400],
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.blue[400],
                          size: 50.0,
                        ),
                      ),
                      accountName: Text("${variable.data['name']}",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      accountEmail: Text("${variable.data['phone']}",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    Divider(),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("Logout"),
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
            ),])
          ),
          appBar: AppBar(
            title: Text("Verify Donor"),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
          ),
          body: ListView(key: _formKey, children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(top: 62),
                child: Column(key: _formKey, children: <Widget>[
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
                    child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Full Name',
                        ),
                        validator: (val) =>
                        val.isEmpty ? 'Enter Donor Name' : null,
                        onChanged: (val) {
                          setState(() => fullNameInputController.text = val);
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
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
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      validator: emailValidator,
                    ),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
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
                    child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Select Blood Group',
                        ),
                        items: bloodgrps.map((bloodgroupInputController) {
                          return DropdownMenuItem(
                            value: bloodgroupInputController,
                            child: Text('$bloodgroupInputController'),
                          );
                        }).toList(),
                        validator: (val) =>
                        val.isEmpty ? 'Select your blood group' : null,
                        onChanged: (val) {
                          setState(() => bloodgroupInputController.text = val);
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  InkWell(
                    onTap: () async {
                      DocumentSnapshot variablee = await Firestore.instance
                          .collection('userInfo')
                          .document(emailInputController.text)
                          .get();
                      if (variablee.data['bloodgroup'] ==
                          bloodgroupInputController.text) {
                        try {
                          await Firestore.instance
                              .collection('userInfo')
                              .document(emailInputController.text)
                              .updateData({'verified': "Yes"});
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Donor Verified"),
                          ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MediDash(
                                    uid: widget.uid,
                                  ))).then((result) {
                            Navigator.of(context).pop();
                          });
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("${e.toString()}"),
                          ));
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Blood group couldn't match"),
                        ));
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
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Verify'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ]))
          ]));
    }
  }
}