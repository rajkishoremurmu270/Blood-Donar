import 'package:app/loading.dart';
import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:collection';
import 'package:toast/toast.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';

class SignupPage extends StatefulWidget {
  SignupPage({Key key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController fullNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;
  TextEditingController alcohalicInputController;
  TextEditingController bloodgroupInputController;
  TextEditingController phoneInputController;
  TextEditingController verifiedInputController;
  TextEditingController donatednoInputController;
  TextEditingController lastdateInputController;
  TextEditingController locationInputController;
  GeoPoint location;
  TextEditingController ageInputController;
  //final FirebaseMessaging _fcm = FirebaseMessaging();
  String fcmToken;
  bool loading = false;

  void getToken() async {
    //fcmToken = await _fcm.getToken();
    print(fcmToken);
  }

  @override
  initState() {
    fullNameInputController = new TextEditingController();
    alcohalicInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
    bloodgroupInputController = new TextEditingController();
    phoneInputController = new TextEditingController();
    verifiedInputController = new TextEditingController();
    donatednoInputController = new TextEditingController();
    lastdateInputController = new TextEditingController();
    ageInputController = new TextEditingController();
    locationInputController = new TextEditingController();
    SystemChrome.setEnabledSystemUIOverlays([]);
    getToken();
    super.initState();
  }

  Set<Marker> _markers = HashSet<Marker>();
  int _markerIdCounter = 1;
  bool _isMarker = false;
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();
  LatLng position;
  GeoPoint donorlocation;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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

  final List<String> alco_smoker = ['Yes', 'No'];

  Future<void> showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
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

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  void _setMarkers(LatLng point) {
    final String markerIdVal = 'marker_id_$_markerIdCounter';
    _markerIdCounter++;
    setState(() {
      print(
          'Marker | Latitude: ${point.latitude}  Longitude: ${point.longitude}');
      _markers.add(
        Marker(
          markerId: MarkerId(markerIdVal),
          position: point,
        ),
      );
    });
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude), zoom: 15),
        ),
      );
    });
  }

  List<Marker> myMarker = [];

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: 600,
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
                        'User Sign Up',
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
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Age',
                        ),
                        controller: ageInputController,
                        validator: (value) {
                          if (int.parse(value) < 18) {
                            return "You are below 18";
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
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Select Blood Group',
                          ),
                          items:
                          bloodgrps.map((bloodgroupInputController) {
                            return DropdownMenuItem(
                              value: bloodgroupInputController,
                              child: Text('$bloodgroupInputController'),
                            );
                          }).toList(),
                          validator: (val) => val.isEmpty
                              ? 'Select your blood group'
                              : null,
                          onChanged: (val) {
                            setState(() =>
                            bloodgroupInputController.text = val);
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
                      child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Are you Alcohalic/Smoker?',
                          ),
                          items:
                          alco_smoker.map((alcohalicInputController) {
                            return DropdownMenuItem(
                              value: alcohalicInputController,
                              child: Text('$alcohalicInputController'),
                            );
                          }).toList(),
                          validator: (val) => val.isEmpty
                              ? 'Select your blood group'
                              : null,
                          onChanged: (val) {
                            setState(() =>
                            alcohalicInputController.text = val);
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
                                .collection("userInfo")
                                .document(currentUser.user.email)
                                .setData({
                              "name":
                              fullNameInputController.text,
                              "phone": phoneInputController.text,
                              "bloodgroup":
                              bloodgroupInputController.text,
                              "last_donated": null,
                              "alcohalic":
                              alcohalicInputController.text,
                              "verified": "No",
                              "#donated": 0,
                              "location": null,
                              "age": int.parse(
                                  ageInputController.text),
                              "userid": currentUser.user.uid,
                              "email": currentUser.user.email,
                              "available": true,
                              "token": fcmToken
                            })
                                .then((result) => {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomePage(
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
                              bloodgroupInputController
                                  .clear(),
                              lastdateInputController.clear(),
                              alcohalicInputController
                                  .clear(),
                              verifiedInputController.clear(),
                              donatednoInputController
                                  .clear(),
                              locationInputController.clear(),
                              ageInputController.clear()
                            })
                                .catchError((err) => showToast(
                                err.toString(),
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM)))
                                .catchError((err) => showToast(
                                err.toString(),
                                duration: Toast.LENGTH_LONG,
                                gravity: Toast.BOTTOM));
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

  getLocation(BuildContext context) async {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tap Your Location"),
        backgroundColor: Colors.blue[400],
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[400],
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.done, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition:
              CameraPosition(target: _initialcameraposition),
              mapType: MapType.normal,
              onMapCreated: _onMapCreated,
              markers: Set.from(myMarker),
              onTap: _handleTap,
              myLocationEnabled: true,
            ),
          ],
        ),
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
      position = tappedPoint;
      donorlocation = GeoPoint(position.latitude, position.longitude);
      setState(() {
        location = donorlocation;
        print(location);
      });
      print(donorlocation);
    });
  }
}