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
                    wordSpacing: -7,
                    color: Colors.blue.shade800),
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
                  color: Colors.red,
                ),
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
<<<<<<< HEAD
              SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "",
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: "customFont",
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.copyright,
                    size: 17,
                    color: Colors.red,
                  ),
                ],
              ),
=======
              // SizedBox(
              //   height: 100,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: <Widget>[
              //     Text(
              //       "by PLEBITS LLC 2019",
              //       style: TextStyle(
              //           color: Colors.red,
              //           fontFamily: "customFont",
              //           fontWeight: FontWeight.bold),
              //     ),
              //     Icon(
              //       Icons.copyright,
              //       size: 17,
              //       color: Colors.red,
              //     ),
              //   ],
              // ),
>>>>>>> f9e41f86a123246516d574a49f31c97cb217c75c
            ],
          ),
        ],
      ),
    );
  }
}
