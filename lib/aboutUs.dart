import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(null, 100),
        child: Container(
          decoration: BoxDecoration(boxShadow: [
//            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 2)
          ]),
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(80),
                bottomRight: Radius.circular(80)),
            child: Container(
              color: Colors.redAccent,
              child: Center(
                child: Text(
                  "About Us",
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 20,
                width: 20,
              ),
              Text(
                "Alexandria STEM School",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: "customFont",
                    fontWeight: FontWeight.w900,
                    wordSpacing: -7, color: Colors.blue.shade800),
              ),
              Image.asset(
                "assets/logo.png",
                height: 300,
              ),
              Text(
                "Capstone Group details:",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Group Number: 12309\n- Hagar Ezzat\n- Heba Mabrouk\n- Mai Mohamed",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade900),
              ),
              // TODO: Add this shit hahahha
//              School logo => image
//              School name => text(ALEXANDRIA STEM SCHOOL)
//            team members => text size كبيرc
//            member 1 => text صغير
//            member 2 => text 2 صغير
//            member 3 => text 3 صغير
//            Plebits LLC 2019 icon(copyright) => small text in the bottom
//
            ],
          ),
        ],
      ),
    );
  }
}
