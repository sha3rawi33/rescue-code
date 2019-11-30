import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyDashboard extends StatefulWidget {
  @override
  _EmergencyDashboardState createState() => _EmergencyDashboardState();
}

class _EmergencyDashboardState extends State<EmergencyDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEEEEE),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.redAccent,
        title: Text("EMERGENCY"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
            width: 30,
          ),
          Center(
            child: Container(
                width: MediaQuery.of(context).size.width,
                child: Text(
                  "This is what you shall do\nin case of an emergency action",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,),
                  textAlign: TextAlign.center,
                )),
          ),
          SizedBox(
            height: 20,
            width: 30,
          ),
          _buildEmergencyOption1(),
          _buildEmergencyOption2(),
        ],
      ),
    );
  }

  Widget _buildEmergencyOption1() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.red,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    FontAwesomeIcons.ambulance,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                      child: Text(
                    "Call an ambulance \nto your location",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  )),
                  flex: 3,
                )
              ],
            ),
          ),
          onTap: () {
            launch("tel:123");
          },
        ),
      ),
    );
  }

  static const url = "https://www.mayoclinic.org/first-aid";

  Widget _buildEmergencyOption2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.green,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Icon(
                    FontAwesomeIcons.firstAid,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Center(
                      child: Text(
                    "Detailed First-Aid \n instructions",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                    ),
                  )),
                  flex: 3,
                )
              ],
            ),
          ),
          onTap: () {
            launch(url);
          },
        ),
      ),
    );
  }
}
