import 'package:app/screens/home/homemedi/medidash.dart';
import 'package:app/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/home/homedonor/home.dart';
import 'package:app/screens/login/login.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.blue[400], // status bar color
  ));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Wrapper(), routes: <String, WidgetBuilder>{
      '/home': (BuildContext context) => HomePage(),
      '/homemedi': (BuildContext context) => MediDash(),
      '/login': (BuildContext context) => LoginPage(),
    });
  }
}
