import 'package:flutter/material.dart';
import 'chatList.dart';
import 'landingPage.dart';
import 'loginScreen.dart';
import 'signUpScreen.dart';
import 'ambulance.dart';
import 'onBoardingScreen.dart';
import 'welcomePage.dart';

void main() => runApp(MaterialApp(
      title: "RescueCode",
      home: new Scaffold(
        body: WelcomePage(),
      ),
      routes: {
        "login": (context) => new LoginPage(),
        "signup": (context) => new SignUpPage(),
        "landingpage": (context) => new LandingPage(),
        "ambulance": (context) => new EmergencyDashboard(),
        "boarding": (context) => new OnBoardingScreen(),
        "doctors":(context)=> ChatList()
      },
    ));
