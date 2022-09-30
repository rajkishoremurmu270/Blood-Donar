import 'package:app/screens/home/homemedi/medidash.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/screens/service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Donated extends StatefulWidget {
  Donated({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;
  @override
  _DonatedState createState() => _DonatedState();
}

class _DonatedState extends State<Donated> {
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

  int donatedno;

  TextEditingController dateCtl = TextEditingController();
  TextEditingController emailInputController;
  DateTime selectedDate = DateTime.now();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  var newFormat = DateFormat("yy-MM-dd");
  String updatedDt;
  var requestid;
  QuerySnapshot deletion;
  var deletions, len;

  @override
  void initState() {
    database();
    dateCtl = new TextEditingController();
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
          title: Text("Update"),
          backgroundColor: Colors.blue[400],
          centerTitle: true,
        ),
        /*floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red[400],
        onPressed: () {},
        child: Icon(Icons.search, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,*/
        body: ListView(
          key: _formKey,
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 62),
              child: Column(
                key: _formKey,
                children: <Widget>[
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
                    height: 20.0,
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
                          hintText: 'Enter the request id',
                        ),
                        validator: (val) =>
                        val.isEmpty ? 'Enter the request id' : null,
                        onChanged: (val) {
                          setState(() => requestid = val);
                        }),
                  ),
                  SizedBox(
                    height: 20.0,
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
                        controller: dateCtl,
                        decoration: InputDecoration(
                          hintText: "Date of Donation",
                        ),
                        onTap: () async {
                          DateTime date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now());

                          updatedDt = newFormat.format(date);
                          dateCtl.text = updatedDt;
                        },
                      )),
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    onTap: () async {
                      variable = await Firestore.instance
                          .collection('userInfo')
                          .document(emailInputController.text)
                          .get();
                      if (variable.data['#donated'] == null) {
                        donatedno = 1;
                      } else {
                        donatedno = variable.data['#donated'] + 1;
                      }
                      await Firestore.instance
                          .collection('userInfo')
                          .document(emailInputController.text)
                          .updateData({
                        '#donated': donatedno,
                        'last_donated': dateCtl.text
                      });
                      deletion = await Firestore.instance
                          .collection('request_donor')
                          .where('requestid', isEqualTo: requestid)
                          .getDocuments();

                      deletions = deletion.documents
                          .map((doc) => doc.documentID)
                          .toList();
                      len = deletions.length;
                      int index = 0;

                      for (index = 0; index < len; index++) {
                        await Firestore.instance
                            .collection('request_donor')
                            .document(deletions[index])
                            .delete();
                      }

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MediDash(
                                uid: widget.uid,
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
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Update'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

/*_selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      updatedDt = newFormat.format(picked);
    setState(() {
      selectedDate = updatedDt;
    });
  }*/
}