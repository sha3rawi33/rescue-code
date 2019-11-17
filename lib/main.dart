import 'package:flutter/material.dart';
import 'landingPage.dart';
import 'loginScreen.dart';
import 'signUpScreen.dart';
import 'profilePage.dart';
import 'ambulance.dart';

void main() => runApp(MaterialApp(
      title: "RescueCode",
      home: new Scaffold(
        body: ProfilePage(),
      ),
      routes: {
        "login": (context) => new LoginPage(),
        "signup": (context) => new SignUpPage(),
        "profile": (context) => new ProfilePage(),
        "landingpage": (context) => new landingPage(),
        "ambulance": (context) => new EmergencyDashboard(),
      },
    ));
