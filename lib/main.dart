import 'package:flutter/material.dart';
import 'landingPage.dart';
import 'loginScreen.dart';
import 'signUpScreen.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(fontFamily: 'customFont'),
      title: "RescueCode",
      home: new Scaffold(
        body: landingPage(),
      ),
      routes: {
        "login": (context) => new LoginPage(),
        "signup": (context) => new SignUpPage(),
      },
    ));
