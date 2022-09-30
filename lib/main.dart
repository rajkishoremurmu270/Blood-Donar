import 'package:app/screens/home/homemedi/medidash.dart';
import 'package:app/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/login/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'Remove Debug Banner';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,
        home: Wrapper(), routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => HomePage(),
      '/homemedi': (BuildContext context) => MediDash(),
      '/login': (BuildContext context) => LoginPage(),
    });
  }
}