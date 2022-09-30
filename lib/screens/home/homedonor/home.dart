import 'dart:math';
import 'package:app/loading.dart';
import 'package:app/screens/home/homedonor/accepted.dart';
import 'package:app/screens/home/homedonor/myrequets.dart';
import 'package:app/screens/home/homedonor/requestdonor.dart';
import 'package:app/screens/home/homedonor/updatelocation.dart';
import 'package:app/screens/home/homedonor/updateprofile.dart';
import 'package:app/screens/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
//update the constructor to include the uid
  final String title;
  final String uid; //include this
  HomePage({Key key, this.title, this.uid}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DocumentSnapshot variable;
  List<DocumentSnapshot> request = List<DocumentSnapshot>();
  List<DocumentSnapshot> seekers = List<DocumentSnapshot>();
  DocumentSnapshot seeker;
  QuerySnapshot stream;
  var variablee;
  var requestId, requestiid;
  var len;
  var lat, long;
  var state, state1;
  int _value = 1;

  var isRequested = [false, false];
  bool isSwitched = false;

  //final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

//     _getToken(){
//     _firebaseMessaging.getToken().then((deviceToken){
//       token=deviceToken;
//       print("Device Token: $deviceToken");
//     });
//   }

  _configureFirebaseListeners() {
    /*_firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );*/
  }

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
    if (_value == 1) {
      stream = await Firestore.instance
          .collection('request_donor')
          .where('donoremail', isEqualTo: widget.uid)
          .where('accepted', isEqualTo: false)
          .orderBy('distance', descending: false)
          .getDocuments();
    }
    if (_value == 2) {
      stream = await Firestore.instance
          .collection('request_donor')
          .where('donoremail', isEqualTo: widget.uid)
          .where('accepted', isEqualTo: false)
          .orderBy('date', descending: false)
          .getDocuments();
    }
    if (_value == 3) {
      stream = await Firestore.instance
          .collection('request_donor')
          .where('donoremail', isEqualTo: widget.uid)
          .where('accepted', isEqualTo: false)
          .orderBy('age', descending: true)
          .getDocuments();
    }
    if (_value == 4) {
      stream = await Firestore.instance
          .collection('request_donor')
          .where('donoremail', isEqualTo: widget.uid)
          .where('accepted', isEqualTo: false)
          .orderBy('age', descending: false)
          .getDocuments();
    }

    if (requestId != null) requestId.clear;
    if (request != null) request = List<DocumentSnapshot>();
    print(request);
    if (seekers != null) seekers = List<DocumentSnapshot>();
    if (isRequested != null) isRequested.clear;
    requestId = stream.documents.map((doc) => doc.data).toList();
    requestiid = stream.documents.map((doc) => doc.documentID).toList();
    print(stream);
    print(requestId);
    if (requestId != null) {
      len = requestId.length;
    } else
      len = 0;
    int index = 0;

    for (index = 0; index < len; index++) {
      var abcd = await Firestore.instance
          .collection('request')
          .document(requestId[index]['requestid'])
          .get();
      print(requestiid[index]);
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
    _configureFirebaseListeners();
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
              child: Column(children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  /*child: ListTile(
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
                      accountName: Text("${variablee.data['name']}",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                      accountEmail: Text("${variablee.data['email']}",
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
                          Icons.pin_drop,
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
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("Accepted requests"),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Accepted(
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
                          Icons.request_page,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("My requests"),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Myrequets(
                                      uid: widget.uid,
                                    )));
                      },
                    ),
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
          ])),
          appBar: AppBar(
            title: Text("Request From Seekers"),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.blue[400],
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RequestDonor(
                            uid: widget.uid,
                          ))).then((result) {
                Navigator.of(context).pop();
              });
            },
            label: Text("In need of Blood? Search Donors"),
            icon: Icon(Icons.search, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Center(
              child: ListView(children: <Widget>[
            ListTile(
              trailing: Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: toggleSwitch,
                    value: isSwitched,
                    activeColor: Colors.red,
                    activeTrackColor: Colors.blueGrey,
                    inactiveThumbColor: Colors.grey,
                    inactiveTrackColor: Colors.blueGrey,
                  )),
              title: Text("Availability for donation"),
            ),
            DropdownButton(
                value: _value,
                items: [
                  DropdownMenuItem(
                    child: Text("sort by distance"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("sort by date"),
                    value: 2,
                  ),
                  DropdownMenuItem(
                    child: Text("sort by age, old to young"),
                    value: 3,
                  ),
                  DropdownMenuItem(
                    child: Text("sort by age, young to old"),
                    value: 4,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                  getData();
                }),
            Text(
              '\nTap on the accept button to get details of seeker\n',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontStyle: FontStyle.italic),
            ),
            SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(children: <Widget>[
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
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
                                    color: Colors.red[400],
                                    size: 40.0,
                                  ),
                                  //backgroundImage: AssetImage('assets/O+.png'),
                                ),
                                title: Text("Guest"),
                                subtitle: Column(
                                  children: <Widget>[
                                    Text(
                                        'patients name: ${request[index]['name']}\n${roundDouble(requestId[index]['distance'], 1)} km away \ndate needed by: ${request[index]['date_needed']}\nAge-${request[index]['age']} \nreason-${request[index]['reason']}'),
                                    new RaisedButton(
                                        child: isRequested[index]
                                            ? Text("Accepted")
                                            : Text("Accept"),

                                        // 2
                                        color: isRequested[index]
                                            ? Colors.red
                                            : Colors.grey,

                                        // 3
                                        onPressed: () async {
                                          await Firestore.instance
                                              .collection('request_donor')
                                              .document(requestiid[index])
                                              .updateData({'accepted': true});
                                          if (isRequested[index] == false) {
                                            showAlertDialog(
                                                context,
                                                request[index]['phone'],
                                                request[index]['location']
                                                        ['geopoint']
                                                    .latitude,
                                                request[index]['location']
                                                        ['geopoint']
                                                    .longitude);
                                          }
                                          ;
                                          setState(() {
                                            isRequested[index] = true;
                                          });
                                        }),
                                  ],
                                ),
                              ));
                        } else {
                          return Card(
                              margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                              child: ListTile(
                                leading: CircleAvatar(
                                  radius: 25.0,
                                  backgroundColor: Colors.green[200],
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.red[400],
                                    size: 40.0,
                                  ),
                                  //backgroundImage: AssetImage('assets/O+.png'),
                                ),
                                title: Text(seekers[index].data['name']),
                                subtitle: Column(
                                  children: <Widget>[
                                    Text(
                                        'patients name: ${request[index]['name']}\n${roundDouble(requestId[index]['distance'], 1)} km away \ndate needed by: ${request[index]['date_needed']}\nAge-${request[index]['age']}  \nNo. of times Donated-${seekers[index]['#donated']}\nreason-${request[index]['reason']}'),
                                    new RaisedButton(
                                        child: isRequested[index]
                                            ? Text("Accepted")
                                            : Text("Accept"),

                                        // 2
                                        color: isRequested[index]
                                            ? Colors.red
                                            : Colors.grey,

                                        // 3
                                        onPressed: () async {
                                          await Firestore.instance
                                              .collection('request_donor')
                                              .document(requestiid[index])
                                              .updateData({'accepted': true});
                                          if (isRequested[index] == false) {
                                            showAlertDialog(
                                                context,
                                                request[index]['phone'],
                                                request[index]['location']
                                                        ['geopoint']
                                                    .latitude,
                                                request[index]['location']
                                                        ['geopoint']
                                                    .longitude);
                                          }
                                          ;
                                          setState(() {
                                            isRequested[index] = true;
                                          });
                                        }),
                                  ],
                                ),
                              ));
                        }
                      }),
                ]))
          ])
              /*body: StreamBuilder(
          stream: stream
          ,
          /*builder: (context, userSnapshot) {
            return userSnapshot.hasData
                ? ListView.builder(
                itemCount: userSnapshot.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot userData =
                  userSnapshot.data.documents[index];
                  request = await Firestore.instance
                      .collection('request')
                      .document(userData.data['requestid'])
                      .get();
                  seeker = await Firestore.instance
                      .collection('userInfo')
                      .document(request.data['email'])
                      .get();
                  return Card(
                    margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Colors.green[200],
                        //backgroundImage: AssetImage('assets/O+.png'),
                      ),
                      title: Text(seeker.data['name']),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                              'Date-${userData.data['date']} \n#donated-${seeker.data['#donated']}'),
                          /*RaisedButton(
                          child: isRequested[index]
                              ? Text("Requested")
                              : Text("Request"),
                          // 2
                          color: isRequested[index] ? Colors.blue : Colors.grey,
                          // 3
                          /*onPressed: () => {
                            if (isRequested[index] == false)
                              {
                                addrequestdonor(stream[index].data['email'],
                                    widget.requestid)
                              },
                            setState(() {
                              isRequested[index] = true;
                            }),
                          },*/
                        )*/
                        ],
                      ),
                    ),
                  );
                })
                : CircularProgressIndicator();
          },*/
        ),*/
              ));
    } else {
      if (variable != null) {
        return Scaffold(
            drawer: Drawer(
                child: Column(children: <Widget>[
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
                        accountName: Text("${variablee.data['name']}",
                            style: TextStyle(
                              color: Colors.white,
                            )),
                        accountEmail: Text("${variablee.data['email']}",
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
                            Icons.pin_drop,
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
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[400],
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        title: Text("Accepted requests"),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Accepted(
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
                            Icons.request_page,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        title: Text("My requests"),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Myrequets(
                                        uid: widget.uid,
                                      )));
                        },
                      ),
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
            ])),
            appBar: AppBar(
              title: Text("Request From Seekers"),
              backgroundColor: Colors.blue[400],
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.blue[400],
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestDonor(
                              uid: widget.uid,
                            ))).then((result) {
                  Navigator.of(context).pop();
                });
              },
              label: Text("In need of Blood? Search Donors"),
              icon: Icon(Icons.search, color: Colors.white),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Center(
                child: ListView(children: <Widget>[
              ListTile(
                trailing: Transform.scale(
                    scale: 1,
                    child: Switch(
                      onChanged: toggleSwitch,
                      value: isSwitched,
                      activeColor: Colors.red,
                      activeTrackColor: Colors.blueGrey,
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.blueGrey,
                    )),
                title: Text("Availability for donation"),
              ),
              Text("No Requests..."),
            ])));
      } else
        return Scaffold(
            drawer: Drawer(
                child: Column(children: <Widget>[
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
                            Icons.pin_drop,
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
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue[400],
                          child: Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        title: Text("Accepted requests"),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Accepted(
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
                            Icons.request_page,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                        title: Text("My requests"),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Myrequets(
                                        uid: widget.uid,
                                      )));
                        },
                      ),
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
            ])),
            appBar: AppBar(
              title: Text("Request From Seekers"),
              backgroundColor: Colors.blue[400],
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blue[400],
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RequestDonor(
                              uid: widget.uid,
                            ))).then((result) {
                  Navigator.of(context).pop();
                });
              },
              child: Icon(Icons.search, color: Colors.white),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            body: Center(
              child: Text("No Requests..."),
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
  Widget optionTwo = SimpleDialogOption(
    child: Text('Get the location'),
    onPressed: () =>
        launch("http://www.google.com/maps/search/?api=1&query=$lat,$long"),
  );
  SimpleDialog dialog = SimpleDialog(
    title: const Text('confirm?'),
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
