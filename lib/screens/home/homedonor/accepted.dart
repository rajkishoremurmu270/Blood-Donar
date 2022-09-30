import 'dart:math';
import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/home/homedonor/updatelocation.dart';
import 'package:app/screens/home/homedonor/updateprofile.dart';
import 'package:app/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Accepted extends StatefulWidget {
//update the constructor to include the uid
  final String title;
  final String uid; //include this
  Accepted({Key key, this.title, this.uid}) : super(key: key);

  @override
  _AcceptedState createState() => _AcceptedState();
}

class _AcceptedState extends State<Accepted> {
  DocumentSnapshot variable;
  List<DocumentSnapshot> request = List<DocumentSnapshot>();
  List<DocumentSnapshot> seekers = List<DocumentSnapshot>();
  DocumentSnapshot seeker;
  QuerySnapshot stream;
  var variablee;
  var requestId;
  var len;
  var lat, long;
  var state, state1;
  var requestiid;
  int _value = 1;

  var isRequested = [false, false];
  bool isSwitched = false;

  void database() async {
    variable = await Firestore.instance
        .collection('userInfo')
        .document(widget.uid)
        .get();
    isSwitched = variable.data['available'];
    if (variable.data['location'] == null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UpdateLocation(
                uid: widget.uid,
              ))).then((result) {
        Navigator.of(context).pop();
      });
    }
    setState(() {
      variablee = variable;
    });
  }

  void getData() async {
    if (stream != null) stream = null;

    stream = await Firestore.instance
        .collection('request_donor')
        .where('donoremail', isEqualTo: widget.uid)
        .where('accepted', isEqualTo: true)
        .orderBy('distance', descending: false)
        .getDocuments();

    if (requestId != null) requestId.clear;
    if (request != null) request = List<DocumentSnapshot>();
    print(request);
    if (seekers != null) seekers = List<DocumentSnapshot>();
    if (isRequested != null) isRequested.clear;
    requestId = stream.documents.map((doc) => doc.data).toList();
    requestiid = stream.documents.map((doc) => doc.documentID).toList();
    print(stream);
    print(requestId);

    len = requestId.length;
    int index = 0;

    for (index = 0; index < len; index++) {
      var abcd = await Firestore.instance
          .collection('request')
          .document(requestId[index]['requestid'])
          .get();
      request.add(abcd);
    }
    print(request);
    for (index = 0; index < len; index++) {
      seekers.add(await Firestore.instance
          .collection('userInfo')
          .document(request[index]['email'])
          .get());
    }
    print(seekers);
    setState(() {
      state = request;
      state1 = seekers;
    });
    index = 0;
  }

  var textValue = 'Switch is OFF';

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      setState(() async {
        await Firestore.instance
            .collection('userInfo')
            .document(widget.uid)
            .updateData(
          {'available': true},
        );
      });
      print('Switch Button is ON');
    } else {
      setState(() /*async*/ {
        isSwitched = false;
      });
      setState(() async {
        await Firestore.instance
            .collection('userInfo')
            .document(widget.uid)
            .updateData(
          {'available': false},
        );
      });
      print('Switch Button is OFF');
    }
  }

  @override
  void initState() {
    database();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getData();
    if (variable != null &&
        requestId != null &&
        request.length > 0 &&
        seekers.length > 0) {
      return Scaffold(
          drawer: Drawer(
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
                    accountEmail: Text("${variable.data['email']}",
                        style: TextStyle(
                          color: Colors.white,
                        )),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[400],
                      child: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                    title: Text("Profile Settings"),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdatePage(
                                uid: widget.uid,
                              ))).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[400],
                      child: Icon(
                        Icons.map,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                    title: Text("Update Location"),
                    onTap: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UpdateLocation(
                                uid: widget.uid,
                              ))).then((result) {
                        Navigator.of(context).pop();
                      });
                    },
                  ),
                  /*ListTile(
                    trailing: Transform.scale(
                        scale: 1,
                        child: Switch(
                          onChanged: toggleSwitch,
                          value: isSwitched,
                          activeColor: Colors.blue,
                          activeTrackColor: Colors.blueGrey,
                          inactiveThumbColor: Colors.grey,
                          inactiveTrackColor: Colors.blueGrey,
                        )),
                    title: Text("Availability"),
                  ),*/
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
          ),
          appBar: AppBar(
            title: Text("Accepted requests"),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[400],
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                        uid: widget.uid,
                      )));
            },
            child: Icon(Icons.home, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Center(
              child: ListView(children: <Widget>[
              SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Column(children: <Widget>[
                    ListView.builder(
                shrinkWrap: true,
                itemCount: requestId.length,
                itemBuilder: (context, index) {
                  if (isRequested.length <= index) isRequested.add(false);
                  if (request[index]['email'] == null) {
                    return Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundColor: Colors.green[200],
                              child: Icon(
                                Icons.person,
                                color: Colors.blue[400],
                                size: 40.0,
                              ),
                              //backgroundImage: AssetImage('assets/O+.png'),
                            ),
                            title: Text("Guest"),
                            subtitle: Column(children: <Widget>[
                              Text(
                                  'patients name: ${request[index]['name']}\n${roundDouble(requestId[index]['distance'], 1)} km away \nAge-${request[index]['age']}  \nreason-${request[index]['reason']} \nrequest ID-${requestiid[index]}\nShow this request ID to hospital where you donate'),
                              new RaisedButton(
                                  child: Text("Details"),

                                  // 2
                                  color: isRequested[index]
                                      ? Colors.blue
                                      : Colors.grey,

                                  // 3
                                  onPressed: () => {
                                    showAlertDialog(
                                        context,
                                        request[index]['phone'],
                                        request[index]['location']
                                        ['geopoint']
                                            .latitude,
                                        request[index]['location']
                                        ['geopoint']
                                            .longitude),
                                  }),
                            ])));
                  } else {
                    return Card(
                        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 25.0,
                            backgroundColor: Colors.green[200],
                            child: Icon(
                              Icons.person,
                              color: Colors.blue[400],
                              size: 40.0,
                            ),
                            //backgroundImage: AssetImage('assets/O+.png'),
                          ),
                          title: Text(seekers[index].data['name']),
                          subtitle: Column(
                            children: <Widget>[
                              Text(
                                  'patients name: ${request[index]['name']}\n${roundDouble(requestId[index]['distance'], 1)} km away \nAge-${request[index]['age']}  \nNo. of times Donated-${seekers[index]['#donated']}\nreason-${request[index]['reason']} \nrequest ID-${requestiid[index]}\nShow this request ID to hospital where you donate'),
                              new RaisedButton(
                                  child: Text("Details"),

                                  // 2
                                  color: isRequested[index]
                                      ? Colors.red
                                      : Colors.grey,

                                  // 3
                                  onPressed: () => {
                                    showAlertDialog(
                                        context,
                                        request[index]['phone'],
                                        request[index]['location']
                                        ['geopoint']
                                            .latitude,
                                        request[index]['location']
                                        ['geopoint']
                                            .longitude),
                                  }),
                            ],
                          ),
                        ));
                  }
                })
             ]) )])));
    } else {
      if(variable != null){
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
                      accountEmail: Text("${variable.data['email']}",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("Profile Settings"),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdatePage(
                                  uid: widget.uid,
                                ))).then((result) {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.map,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("Update Location"),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateLocation(
                                  uid: widget.uid,
                                ))).then((result) {
                          Navigator.of(context).pop();
                        });
                      },
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
            title: Text("Home Page"),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[400],
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                        uid: widget.uid,
                      ))).then((result) {
                Navigator.of(context).pop();
              });
            },
            child: Icon(Icons.home, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Center(
            child: Text(
                "No Accepted Requests\nThe requests you accept will appear here."),
          ));}
      else return Scaffold(
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
                      accountName: Text("none",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      accountEmail: Text("none",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("Profile Settings"),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdatePage(
                                  uid: widget.uid,
                                ))).then((result) {
                          Navigator.of(context).pop();
                        });
                      },
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.map,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("Update Location"),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateLocation(
                                  uid: widget.uid,
                                ))).then((result) {
                          Navigator.of(context).pop();
                        });
                      },
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
            title: Text("Home Page"),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[400],
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                        uid: widget.uid,
                      ))).then((result) {
                Navigator.of(context).pop();
              });
            },
            child: Icon(Icons.home, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Center(
            child: Text(
                "No Accepted Requests\nThe requests you accept will appear here."),
          ));
    }
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}

showAlertDialog(BuildContext context, String phone, double lat, double long) {
  // set up the list options

  // set up the SimpleDialog
  Widget optionOne = ElevatedButton(
    child: Text('Call $phone'),
    onPressed: () => launch("tel:$phone"),
  );
  Widget optionTwo = ElevatedButton(
    child: Text('Get the location'),
    onPressed: () =>
        launch("http://www.google.com/maps/search/?api=1&query=$lat,$long"),
  );
  SimpleDialog dialog = SimpleDialog(
    title: const Text('details'),
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