import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          new Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.redAccent,
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                image: AssetImage('assets/mountains.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: new Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 250.0),
                  child: Center(
                    child: Icon(
                      Icons.healing,
                      color: Colors.white,
                      size: 60.0,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20.0),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Rescue",
                        style: TextStyle(
                          fontFamily: "customFont",
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ),
                      Text(
                        "Code",
                        style: TextStyle(
                            fontFamily: "customFont",
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
                // Center(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: <Widget>[
                //       Text(
                //         "PLEBITS LLC 2019",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 14.0,
                //             fontFamily: "customFont",
                //             color: Colors.white),
                //       ),
                //       Icon(
                //         Icons.copyright,
                //         color: Colors.white,
                //         size: 20,
                //       )
                //     ],
                //   ),
                // ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 120.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new OutlineButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
//                    color: Colors.redAccent,
                          highlightedBorderColor: Colors.white,

                          onPressed: () =>
                              Navigator.pushNamed(context, "signup"),
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "SIGN UP",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                      const EdgeInsets.only(left: 30.0, right: 30.0, top: 30.0),
                  alignment: Alignment.center,
                  child: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)),
                          color: Colors.white,
                          onPressed: () =>
                              Navigator.pushNamed(context, "login"),
                          child: new Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 20.0,
                            ),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Expanded(
                                  child: Text(
                                    "LOGIN",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
