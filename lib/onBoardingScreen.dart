import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:rescue_code/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'doctorChat.dart';

class OnBoardingScreen extends StatelessWidget {
  final pages = [
    PageViewModel(
      pageColor: Colors.indigo,
      bubbleBackgroundColor: Colors.white,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text(
            'Medical information',
            style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white),
          ),
          Text(
            'Introduce your medical information, anytime, anywhere.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
      mainImage: Image.asset(
        'assets/service1.png',
        width: 370.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black),
    ),
    PageViewModel(
      pageColor: Colors.redAccent,
      iconColor: null,
      bubbleBackgroundColor: Colors.white,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Unique Rescue code',
              style:
                  TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
          Text(
            'Have your own personal rescue code for emergencies',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ],
      ),
      mainImage: Image.asset(
        'assets/service2.png',
        width: 370,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black),
    ),
    PageViewModel(
      pageColor: Colors.green,
      iconColor: null,
      bubbleBackgroundColor: Colors.white,
      title: Container(),
      body: Column(
        children: <Widget>[
          Text('Report Accidents',
              style:
                  TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
          Text(
            'Report Accidents and send your live location to the hospital.',
            style: TextStyle(color: Colors.white, fontSize: 16.0),
          ),
        ],
      ),
      mainImage: Image.asset(
        'assets/service3.png',
        width: 370.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(color: Colors.black),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            IntroViewsFlutter(
              pages,
              onTapDoneButton: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();

                var uid = _prefs.getString("uid");
                var type = _prefs.getString("type");

                if (uid != null && uid != '') {
                  if (type == "doctor") {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => DoctorChat()));
                  } else {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(uid: uid)));
                  }
                } else {
                  Navigator.pushNamed(context, "landingpage");
                }
              },
              showSkipButton: false,
              doneText: Text(
                "Get Started",
              ),
              pageButtonsColor: Colors.white,
              pageButtonTextStyles: new TextStyle(
                // color: Colors.indigo,
                fontSize: 16.0,
                fontFamily: "Regular",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
