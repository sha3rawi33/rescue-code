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
