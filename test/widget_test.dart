// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/home/homedonor/updatelocation.dart';
import 'package:app/screens/login/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/screens/service/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geoflutterfire/geoflutterfire.dart';



import 'dart:math';






void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'test Application',

      home: MyHomePage(title: 'Home page'),
    );
  }

}
class MyHomePage extends StatefulWidget{
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePagestate createState() => _MyHomePagestate();
}

class _MyHomePagestate extends State<MyHomePage> {
  // This widget is the home page of your application.
  var donorCollection = Firestore.instance.collection('userInfo');
  final geo = Geoflutterfire();
  GeoFirePoint center;

  final double radius = 50;
  var stream;
  var len;
  int index = 0;
  var request;
  var requestdata;
  int _value = 1;


  /*Future<void> getData() async {

    request = await Firestore.instance
        .collection('request')
        .document('6znS02rx0im2Rf1NyPTk')
        .get();

    var querySnapshot = Firestore.instance.collection('userInfo')
        .where('bloodgroup', isEqualTo: request.data['blood group'])
        .where('available', isEqualTo: true);

    var x = request.data['maxdistance'].toDouble();
    GeoPoint pos = request.data['location']['geopoint'];
    center = Geoflutterfire().point(latitude: pos.latitude, longitude: pos.longitude);


    stream = await geo
        .collection(collectionRef: querySnapshot)
        .within(center: center, radius: x, field: 'location').first;

    stream.data['distance'].sort((a, b) => (a.compareTo(b)));

    final allData = stream[index].data['email'];

    print(allData);
    print(1);

  }*/

  Future<void> getData() async {

    if(_value == 1){
    request = await Firestore.instance
        .collection('request_donor')
        .where('donoremail', isEqualTo: 'exampleemail')
        .orderBy('requestid')
        .getDocuments();}
    if(_value == 2){
      request = await Firestore.instance
          .collection('request_donor')
          .where('donoremail', isEqualTo: 'exampleemail')
          .orderBy('donoremail')
          .getDocuments();}

    final requestId = request.documents.map((doc)=>doc.data['requestid']).toList();
    var length = requestId.length;
    int index = 0;

    
    requestdata = await Firestore.instance
        .collection('request')
        .where('__name__', whereIn: requestId)
        .getDocuments();

    final allRequestData = requestdata.documents.map((doc)=>doc.data).toList();

    print(allRequestData);
    print(1);

  }
  var abc;
  var allRequestData;


  /*Future<void> getData() async {

    requestdata = await Firestore.instance
        .collection('request')
        .where('email', isEqualTo: widget.uid)
        .getDocuments();



    allRequestData = requestdata.documents.map((doc)=>doc.data).toList();

    print(allRequestData);
    print(1);
    setState(() {
      abc = allRequestData;
    });

  }*/

  @override
  void initState() {
    //getData();
    super.initState();
  }

  /*@override
  Widget build(BuildContext context) {

    //getData();
    print(2);
    if (stream != null) {

      return Scaffold(

        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.blue,
        ),

        body: ListView.builder(
          itemCount: stream.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(stream[index].data['email']),
              subtitle: Text('${roundDouble(stream[index].data['distance'],1)} km away'),
            );
          },
        ),

      );
    }
    else return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),



    );
  }
}*/

/*class MyApp extends StatelessWidget {
  final  collectionReference = Firestore.instance.collection('userInfo');
  final geo = Geoflutterfire();
  final GeoFirePoint center = Geoflutterfire().point(latitude: 12.960632, longitude: 77.641603);
  final double radius = 50;
  //Stream<List<DocumentSnapshot>> stream;

  /*void dte()async{

    stream = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: 'location');

    stream.listen((value) {
      print('1st Sub: $value');
    });*/


  }*/
  @override
  Widget build(BuildContext context) {
    //dte();
    print(1);
    final title = 'test';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
          body: Container(
            padding: EdgeInsets.all(20.0),
            child: DropdownButton(
                value: _value,
                items: [
                  DropdownMenuItem(
                    child: Text("sort by email"),
                    value: 1,
                  ),
                  DropdownMenuItem(
                    child: Text("sort by maxdistance"),
                    value: 2,
                  ),

                ],
                onChanged: (value) {
                  setState(() {
                    _value = value;
                  });
                  //getData();
                }),
          )

      ),
    );

  }
}

double roundDouble(double value, int places){
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}