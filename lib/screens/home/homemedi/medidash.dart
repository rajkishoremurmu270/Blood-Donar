import 'package:app/screens/home/homemedi/donated.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/screens/home/homemedi/verifydonor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MediDash extends StatefulWidget {
  MediDash({Key key, this.title, this.uid}) : super(key: key);
  final String title;
  final String uid;
  @override
  _MediDashState createState() => _MediDashState();
}

class _MediDashState extends State<MediDash> {
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

  @override
  void initState() {
    database();
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
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
          title: Text("Home"),
          backgroundColor: Colors.blue[400],
          centerTitle: true,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(3.0),
            children: <Widget>[
              makeDashboardItem("Verify", Icons.person),
              makeDashboardItem("Donated?", Icons.water_damage)
            ],
          ),
        ),
      );
    }
  }

  Card makeDashboardItem(String title, IconData icon) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
            decoration:
            BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
            child: new InkWell(
                onTap: () {
                  if (title == "Verify") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VerifyDonor(
                            uid: widget.uid,
                          )),
                    );
                  }
                  if (title == "Donated?") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Donated(
                            uid: widget.uid,
                          )),
                    );
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    SizedBox(height: 50.0),
                    Center(
                        child: Icon(
                          icon,
                          size: 40.0,
                          color: Colors.black,
                        )),
                    SizedBox(height: 20.0),
                    new Center(
                      child: new Text(title,
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.black)),
                    )
                  ],
                ))));
  }
}
