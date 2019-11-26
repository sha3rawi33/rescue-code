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

void main() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();

  var uid = _prefs.getString("uid");
  var type = _prefs.getString("type");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "RescueCode",
    home: new Scaffold(
      // if (uid != null && uid != '') {
      //   if (type == "doctor") {
      //     Navigator.pushReplacement(context,
      //         MaterialPageRoute(builder: (context) => DoctorChat()));
      //   } else {
      //     Navigator.pushReplacement(
      //         context,
      //         MaterialPageRoute(
      //             builder: (context) => ProfilePage(uid: uid)));
      //   }
      // } else {
      //   Navigator.pushNamed(context, "landingpage");
      // }
      body: type == "doctor" && uid != null && uid != ''
          ? DoctorChat()
          : uid != null && uid != '' ? ProfilePage(uid: uid) : WelcomePage(),
    ),
    routes: {
      "login": (context) => new LoginPage(),
      "signup": (context) => new SignUpPage(),
      "landingpage": (context) => new LandingPage(),
      "ambulance": (context) => new EmergencyDashboard(),
      "boarding": (context) => new OnBoardingScreen(),
      "doctors": (context) => ChatList(),
      "profile": (context) => ProfilePage(
            uid: uid,
          ),
      "about": (context) => AboutUs(),
    },
  ));
}
