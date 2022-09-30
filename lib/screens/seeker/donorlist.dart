import 'dart:math';
import 'package:app/screens/login/login.dart';
import 'package:app/screens/seeker/homeseek.dart';
import 'package:app/screens/seeker/reqstatus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_functions/cloud_functions.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class DonorList extends StatefulWidget {
//update the constructor to include the uid
  final FirebaseUser user;
  final String title;
  final String requestid; //include this
  DonorList({Key key, this.user, this.title, this.requestid}) : super(key: key);

  @override
  _DonorListState createState() => _DonorListState();
}

class _DonorListState extends State<DonorList> {
  DocumentSnapshot variable, variablee;
  DocumentSnapshot request;
  Future<QuerySnapshot> donlist;
  var collectionReference = Firestore.instance.collection('userInfo');
  var requestRef = Firestore.instance.collection('request_donor');
  final geo = Geoflutterfire();
  var querySnapshot;
  var stream;
  var x;

  GeoPoint pos;
  double dist;
  GeoFirePoint center;
  double radius = 50;
  Future<List<DocumentSnapshot>> listss;
  int b = 0;
  var abc;
  var isRequested = [false, false];

 // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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

  Future<void> sendNotification(String token, String name) async {
    HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'sendNotification');
    final results =
    await callable(<String, dynamic>{'Token': token, 'seekerName': name});

    print(results);
  }

  Future<void> getData() async {
    request = await Firestore.instance
        .collection('request')
        .document(widget.requestid)
        .get();
    // Get docs from collection reference
    querySnapshot = Firestore.instance
        .collection('userInfo')
        .where('bloodgroup', isEqualTo: request.data['blood group'])
        .where('available', isEqualTo: true);

    x = request.data['maxdistance'].toDouble();
    pos = request.data['location']['geopoint'];
    center = Geoflutterfire()
        .point(latitude: pos.latitude, longitude: pos.longitude);

    stream = await geo
        .collection(collectionRef: querySnapshot)
        .within(center: center, radius: x, field: 'location')
        .first;

    print(stream);
    print(1);
    setState(() {
      abc = stream;
    });
  }

  /*void database() async {
    variable = await Firestore.instance
        .collection('userInfo')
        .document(widget.uid)
        .get();
    setState(() async {
      variablee = variable;
    });
  }*/

  @override
  void initState() {
    //database();
    getData();
    _configureFirebaseListeners();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (stream != null) {
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
                    accountName: Text('Guest'),
                    accountEmail: Text(
                      "${widget.user.phoneNumber}",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[400],
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30.0,
                      ),
                    ),
                    title: Text("Request Status"),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Reqstatus(user: widget.user)));
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
                    onTap: () async{
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
          title: Text("Nearby Donors for ${widget.title}"),
          backgroundColor: Colors.blue[400],
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeSeek(
                      //title: variable.data['name'],
                      user: this.widget.user,
                    ))).then((result) {
              Navigator.of(context).pop();
            });
          },
          child: Icon(Icons.home, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: Column(children: <Widget>[
          Text('Tap on the request button to request the donors'),
          ListView.builder(
            shrinkWrap: true,
            itemCount: stream.length,
            itemBuilder: (context, index) {
              if (isRequested.length <= index) isRequested.add(false);
              if (stream[index].data['verified'] == "Yes" && stream[index].data['distance'] < request.data['maxdistance']) {

                return Card(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: ListTile(
                    onTap: () => showAlertDialog(context),
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_user),
                      ],
                    ),
                    title: Text(stream[index].data['name']),
                    subtitle: Column(
                      children: <Widget>[
                        Text(
                            '${roundDouble(stream[index].data['distance'], 1)} km away \nAge-${stream[index].data['age']}  Alcoholic/Smoker-${stream[index].data['alcohalic']}\nLast Donated-${stream[index].data['last_donated']}'),
                        new RaisedButton(
                          child: isRequested[index]
                              ? Text("Requested")
                              : Text("Request"),

                          // 2
                          color: isRequested[index] ? Colors.red : Colors.grey,

                          // 3
                          onPressed: () => {
                            sendNotification(stream[index].data['token'],
                                request.data['name']),
                            if (isRequested[index] == false)
                              {
                                addrequestdonor(
                                    stream[index].data['email'],
                                    widget.requestid,
                                    stream[index].data['distance'],
                                    request.data['age'])
                              },
                            setState(() {
                              isRequested[index] = true;
                            }),
                          },
                        )
                      ],
                    ),
                  ),
                );
              } else {
                if (stream[index].data['distance'] < request.data['maxdistance']){

                return Card(
                  margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
                  child: ListTile(
                    onTap: () => showAlertDialog(context),
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
                    title: Text(stream[index].data['name']),
                    subtitle: Column(
                      children: <Widget>[
                        Text(
                            '${roundDouble(stream[index].data['distance'], 1)} km away \nAge-${stream[index].data['age']}  Alcoholic/Smoker-${stream[index].data['alcohalic']}\nLast Donated-${stream[index].data['last_donated']}'),
                        RaisedButton(
                          child: isRequested[index]
                              ? Text("Requested")
                              : Text("Request"),

                          // 2
                          color: isRequested[index] ? Colors.red : Colors.grey,
                          // 3
                          onPressed: () => {
                            sendNotification(stream[index].data['token'],
                                request.data['name']),
                            if (isRequested[index] == false)
                              {
                                addrequestdonor(
                                    stream[index].data['email'],
                                    widget.requestid,
                                    stream[index].data['distance'],
                                    request.data['age'])
                              },
                            setState(() {
                              isRequested[index] = true;
                            }),
                          },
                        )
                      ],
                    ),
                  ),
                );}
              }
            },
          ),
        ]),
      );
    } else {
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
                      accountName: Text('Guest'),
                      accountEmail: Text(
                        "${widget.user.phoneNumber}",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue[400],
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30.0,
                        ),
                      ),
                      title: Text("Request Status"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Reqstatus(user: widget.user)));
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
            title: Text("Nearby Donors for ${widget.title}"),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue[400],
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeSeek(
                        //title: variable.data['name'],
                        user: this.widget.user,
                      ))).then((result) {
                Navigator.of(context).pop();
              });
            },
            child: Icon(Icons.home, color: Colors.white),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          body: Center(
            child: Text("No Donors found"),
          ));
    }
  }

  double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}

void addrequestdonor(
    String email, String requestId, double distance, int age) async {
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  await Firestore.instance.collection('request_donor').add({
    'donoremail': email,
    'requestid': requestId,
    'date': formattedDate,
    'distance': distance,
    'age': age,
    'accepted': false
  });
}

void showAlertDialog(BuildContext context) {
  // set up the list options
  Widget optionOne = SimpleDialogOption(
    child: const Text('YES'),
    onPressed: () {},
  );
  Widget optionTwo = SimpleDialogOption(
    child: const Text('NO'),
    onPressed: () {},
  );

  // set up the SimpleDialog
  SimpleDialog dialog = SimpleDialog(
    title: const Text('Are you sure to request?'),
    children: <Widget>[
      optionOne,
      optionTwo,
    ],
  );

  // show the dialog
  showDialog(context: context, builder: (BuildContext context) => dialog);
}