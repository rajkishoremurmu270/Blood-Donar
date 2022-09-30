import 'package:app/screens/home/homedonor/accepted.dart';
import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/home/homedonor/myrequets.dart';
import 'package:app/screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/screens/service/auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:collection';
import 'package:geoflutterfire/geoflutterfire.dart';

class UpdateLocation extends StatefulWidget {
  final String title;
  final String uid; //include this
  UpdateLocation({Key key, this.title, this.uid}) : super(key: key);

  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  DocumentSnapshot variable, variablee;
  bool isSwitched = false;
  void database() async {
    variable = await Firestore.instance
        .collection('userInfo')
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

  Set<Marker> _markers = HashSet<Marker>();
  int _markerIdCounter = 1;
  bool _isMarker = false;
  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();
  LatLng position;
  GeoFirePoint donorlocation;
  String bloodgrp;
  String dist;
  String minage;
  final AuthService _auth = AuthService();

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
    if (variable != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Tap To Mark Your Location"),
          backgroundColor: Colors.blue[400],
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue[400],
          onPressed: () => _regis(),
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
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      myMarker = [];
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
      position = tappedPoint;
      donorlocation = Geoflutterfire()
          .point(latitude: position.latitude, longitude: position.longitude);
    });
  }

  void _regis() async {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: Form(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    //width: double.infinity,
                    color: Colors.blue,
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),

                    // padding: EdgeInsets.all(16),
                    onPressed: () async {
                      try {
                        await Firestore.instance
                            .collection('userInfo')
                            .document(widget.uid)
                            .updateData({'location': donorlocation.data});
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Location Updated"),
                        ));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                  uid: widget.uid,
                                )));
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.toString()),
                        ));
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }
}