import 'package:flutter/material.dart';
import 'package:rescue_code/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chatList.dart';
import 'doctorChat.dart';
import 'landingPage.dart';
import 'loginScreen.dart';
import 'signUpScreen.dart';
import 'ambulance.dart';
import 'onBoardingScreen.dart';
import 'welcomePage.dart';
//import 'profilePage.dart';
import 'aboutUs.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "RescueCode",
    home: OnBoardingScreen(),
    routes: {
      "login": (context) => new LoginPage(),
      "signup": (context) => new SignUpPage(),
      "landingpage": (context) => new LandingPage(),
      "ambulance": (context) => new EmergencyDashboard(),
      "boarding": (context) => new OnBoardingScreen(),
      "doctors": (context) => ChatList(),
      "profile": (context) => ProfilePage(
      //      uid: uid,
          ),
      "about": (context) => AboutUs(),
    },
  ));
}
