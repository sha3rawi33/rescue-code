import 'package:flutter/material.dart';
import 'package:rescue_code/welcomePage.dart';
import 'chatList.dart';
import 'landingPage.dart';
import 'loginScreen.dart';
import 'signUpScreen.dart';
import 'ambulance.dart';
import 'onBoardingScreen.dart';
import 'aboutUs.dart';

void main() async {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "RescueCode",
    home: WelcomePage(),
    routes: {
      "login": (context) => new LoginPage(),
      "signup": (context) => new SignUpPage(),
      "landingpage": (context) => new LandingPage(),
      "ambulance": (context) => new EmergencyDashboard(),
      "boarding": (context) => new OnBoardingScreen(),
      "doctors": (context) => ChatList(),
      // "profile": (context) => ProfilePage(
      //   ""
      // ),
      "about": (context) => AboutUs(),
    },
  ));
}
