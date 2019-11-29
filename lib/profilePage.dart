import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sideDraw.dart';

class ProfilePage extends StatefulWidget {
  final uid;
  ProfilePage({@required this.uid});
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  bool dropDownStatus = false;

  final FocusNode myFocusNode = FocusNode();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController mobile = TextEditingController();
  TextEditingController nationalId = TextEditingController();
  String id = '';
  String selectedGender = 'Male';
  dynamic diabetes = false;
  dynamic bloodPresure = false;
  dynamic heardDisease = false;
  dynamic infectious = false;
  dynamic chronic = false;
  TextEditingController diabetesController = TextEditingController();
  TextEditingController bloodPresureController = TextEditingController();
  TextEditingController heardDiseaseController = TextEditingController();
  TextEditingController infectiousController = TextEditingController();
  TextEditingController chronicController = TextEditingController();

  var bloodTypes = <String>[
    "A+",
    "A-",
    "B+",
    "B-",
    "AB+",
    "AB-",
    "O+",
    "O-",
  ];
  String bloodName = 'A+';
  var profileImage;
  TextEditingController government = TextEditingController();
  TextEditingController drugs = TextEditingController();
  TextEditingController address = TextEditingController();

  void getData() async {
    var user =
        await Firestore.instance.collection('users').document(widget.uid).get();
    try {
      final ref =
          FirebaseStorage.instance.ref().child('images/${widget.uid}.png');
      var url = await ref.getDownloadURL();
      setState(() {
        profileImage = url;
      });
    } catch (e) {
      print(e);
    }
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    Map result = user.data;
    name = result['name'] != null && result['name'] != ''
        ? TextEditingController(text: result['name'])
        : TextEditingController();
    _prefs.setString('name', result['name']);
    age = result['age'] != null && result['age'] != ''
        ? TextEditingController(text: result['age'])
        : TextEditingController();
    mobile = result['mobile'] != null && result['mobile'] != ''
        ? TextEditingController(text: result['mobile'])
        : TextEditingController();
    email = result['email'] != null && result['email'] != ''
        ? TextEditingController(text: result['email'])
        : TextEditingController();
    nationalId = result['nationalId'] != null && result['nationalId'] != ''
        ? TextEditingController(text: result['nationalId'])
        : TextEditingController();
    government = result['government'] != null && result['government'] != ''
        ? TextEditingController(text: result['government'])
        : TextEditingController();
    address = result['address'] != null && result['address'] != ''
        ? TextEditingController(text: result['address'])
        : TextEditingController();
    bloodName = result['bloodType'] != null && result['bloodType'] != ''
        ? result['bloodType']
        : null;
    selectedGender = result['gender'] != null && result['gender'] != ''
        ? result['gender']
        : null;
    drugs = result['drugs'] != null && result['drugs'] != ''
        ? TextEditingController(text: result['drugs'])
        : TextEditingController();
    diabetes = result['diabetes'] != null && result['diabetes'] != ''
        ? result['diabetes']
        : false;
    bloodPresure =
        result['bloodPresure'] != null && result['bloodPresure'] != ''
            ? result['bloodPresure']
            : false;
    chronic = result['chronic'] != null && result['chronic'] != ''
        ? result['chronic']
        : false;
    infectious = result['infectious'] != null && result['infectious'] != ''
        ? result['infectious']
        : false;
    heardDisease =
        result['heartDisease'] != null && result['heartDisease'] != ''
            ? result['heartDisease']
            : false;
    id = result['id'];
    setState(() {
      chronicController = TextEditingController(
          text: chronic.toString() == "false" ? '' : chronic);
      diabetesController = TextEditingController(
          text: diabetes.toString() == "false" ? '' : diabetes);
      bloodPresureController = TextEditingController(
          text: bloodPresure.toString() == "false" ? '' : bloodPresure);
      heardDiseaseController = TextEditingController(
          text: heardDisease.toString() == "false" ? '' : heardDisease);
      infectiousController = TextEditingController(
          text: infectious.toString() == "false" ? '' : infectious);
    });
  }

  upload() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference reference =
        FirebaseStorage.instance.ref().child("images/${widget.uid}.png");
    var uploadPhoto = reference.putFile(image);
    await uploadPhoto.onComplete;
    var url = await reference.getDownloadURL();
    setState(() {
      profileImage = url;
    });
  }

  void updateData() async {
    await Firestore.instance
        .collection("users")
        .document(widget.uid)
        .updateData({
      "name": name.text,
      "age": age.text,
      "government": government.text,
      "gender": selectedGender ?? '',
      "bloodType": bloodName ?? '',
      "email": email.text,
      "nationalId": nationalId.text,
      "address": address.text,
      "mobile": mobile.text,
      "heartDisease": heardDisease,
      "chronic": chronic,
      "infectious": infectious,
      "bloodPresure": bloodPresure,
      "diabetes": diabetes,
      "drugs": drugs.text ?? ''
    });
  }

  initializeNotifications() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> message) {
        print('onLaunch called');
        return null;
      },
      onResume: (Map<String, dynamic> message) {
        print('onResume called');
        return null;
      },
      onMessage: (Map<String, dynamic> message) {
        print('onMessage called');
        return null;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    await _firebaseMessaging.getToken().then((token) async {
      await Firestore.instance
          .collection("users")
          .document(widget.uid)
          .updateData({"firebaseToken": token});
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, "doctors"),
          // The Chat Screen // Report,
          child: Icon(
            Icons.report_problem,
            color: Colors.white,
          ),
          backgroundColor: Colors.redAccent,
          hoverColor: Colors.red,
          isExtended: false,
        ),
        drawer: new SideDraw(name.text, profileImage),
        backgroundColor: Colors.pinkAccent.shade100,
        appBar: new AppBar(
          actionsIconTheme: IconThemeData(color: Colors.white),
          title: Text(
            "RESCUE CODE",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: SafeArea(
          child: new Container(
            color: Colors.white,
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      height: 220.0,
                      color: Colors.white,
                      child: new Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 20.0),
                            child: new Stack(fit: StackFit.loose, children: <
                                Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
                                          width: 140.0,
                                          height: 140.0,
                                          decoration: new BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: new DecorationImage(
                                              image: profileImage == null
                                                  ? new ExactAssetImage(
                                                      'assets/profilepic.png')
                                                  : NetworkImage(profileImage),
                                              fit: BoxFit.cover,
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                  padding:
                                      EdgeInsets.only(top: 90.0, right: 100.0),
                                  child: new Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      GestureDetector(
                                        child: new CircleAvatar(
                                          backgroundColor: Colors.red,
                                          radius: 25.0,
                                          child: new Icon(
                                            Icons.camera_alt,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: () {
                                          upload();
                                        }, // Image Picker
                                      )
                                    ],
                                  )),
                            ]),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10.0, right: 0.0),
                              child: new Text(
                                "Rescue Code: $id",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900),
                              )),
                        ],
                      ),
                    ),
                    new Container(
                      color: Color(0xffFFFFFF),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Personal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    new Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        _status
                                            ? _getEditIcon()
                                            : new Container(),
                                      ],
                                    )
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        controller: name,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Your Name",
                                        ),
                                        enabled: !_status,
                                        autofocus: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email Address',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        controller: email,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Email Address"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Mobile',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        controller: mobile,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Mobile Number"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'National ID',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        controller: nationalId,
                                        decoration: const InputDecoration(
                                            hintText: "Enter National ID"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          'Age',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          'Government',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: new TextField(
                                          controller: age,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Your Age"),
                                          enabled: !_status,
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                    Flexible(
                                      child: new TextField(
                                        controller: government,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Government"),
                                        enabled: !_status,
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        controller: address,
                                        decoration: const InputDecoration(
                                            hintText: "Enter your Address"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: new Text(
                                          'Blood Type',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      flex: 2,
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      child: Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: new DropdownButton(
                                            disabledHint: Text("Gender"),
                                            value: selectedGender,
                                            onChanged: !dropDownStatus
                                                ? (v) {
                                                    setState(() {
                                                      selectedGender = v;
                                                    });
                                                  }
                                                : null,
                                            items: [
                                              DropdownMenuItem(
                                                child: Text('Male'),
                                                value: 'Male',
                                              ),
                                              DropdownMenuItem(
                                                child: Text('Female'),
                                                value: 'Female',
                                              ),
                                            ],
                                          )),
                                      //  flex: 2,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: new DropdownButton(
                                          disabledHint:
                                              Center(child: Text("Blood Type")),
                                          items: bloodTypes.map((value) {
                                            return DropdownMenuItem(
                                              child: Text(value),
                                              value: value,
                                            );
                                          }).toList(),
                                          value: bloodName,
                                          onChanged: !dropDownStatus
                                              ? (v) {
                                                  setState(() {
                                                    bloodName = v;
                                                  });
                                                }
                                              : null,
                                        ),
                                      ),
                                      //    flex: 2,
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Diabetes',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Flexible(
                                      child: Checkbox(
                                        value: diabetes != false ? true : false,
                                        activeColor: Colors.red,
                                        onChanged: !_status
                                            ? (value) {
                                                if (value == false) {
                                                  diabetes = false;
                                                  setState(() {});
                                                } else {
                                                  setState(() {
                                                    diabetes =
                                                        diabetesController.text;
                                                  });
                                                }
                                              }
                                            : (s) {},
                                      ),
                                    ),
                                    new Flexible(
                                      child: new TextField(
                                        controller: diabetesController,
                                        decoration: const InputDecoration(
                                            hintText: "Diabetes"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Blood Pressure',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Flexible(
                                      child: Checkbox(
                                        value: bloodPresure != false
                                            ? true
                                            : false,
                                        activeColor: Colors.red,
                                        onChanged: !_status
                                            ? (value) {
                                                if (value == false) {
                                                  bloodPresure = false;
                                                  setState(() {});
                                                } else {
                                                  setState(() {
                                                    bloodPresure =
                                                        bloodPresureController
                                                            .text;
                                                  });
                                                }
                                              }
                                            : (s) {},
                                      ),
                                    ),
                                    new Flexible(
                                      child: new TextField(
                                        controller: bloodPresureController,
                                        decoration: const InputDecoration(
                                            hintText: "Blood Pressure"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Heart Disease',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Flexible(
                                      child: Checkbox(
                                        value: heardDisease != false
                                            ? true
                                            : false,
                                        activeColor: Colors.red,
                                        onChanged: !_status
                                            ? (value) {
                                                if (value == false) {
                                                  heardDisease = false;
                                                  setState(() {});
                                                } else {
                                                  setState(() {
                                                    heardDisease =
                                                        heardDiseaseController
                                                            .text;
                                                  });
                                                }
                                              }
                                            : (s) {},
                                      ),
                                    ),
                                    new Flexible(
                                      child: new TextField(
                                        controller: heardDiseaseController,
                                        decoration: const InputDecoration(
                                            hintText: "Heart Disease"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Any Infectious Disease',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Flexible(
                                      child: Checkbox(
                                        value:
                                            infectious != false ? true : false,
                                        activeColor: Colors.red,
                                        onChanged: !_status
                                            ? (value) {
                                                if (value == false) {
                                                  infectious = false;
                                                  setState(() {});
                                                } else {
                                                  setState(() {
                                                    infectious =
                                                        infectiousController
                                                            .text;
                                                  });
                                                }
                                              }
                                            : (s) {},
                                      ),
                                    ),
                                    new Flexible(
                                      child: new TextField(
                                        controller: infectiousController,
                                        decoration: const InputDecoration(
                                            hintText: "Infectious disease"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Any chronic disease',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Flexible(
                                      child: Checkbox(
                                        value: chronic != false ? true : false,
                                        activeColor: Colors.red,
                                        onChanged: !_status
                                            ? (value) {
                                                if (value == false) {
                                                  chronic = false;
                                                  setState(() {});
                                                } else {
                                                  setState(() {
                                                    chronic =
                                                        chronicController.text;
                                                  });
                                                }
                                              }
                                            : (s) {},
                                      ),
                                    ),
                                    new Flexible(
                                      child: new TextField(
                                        controller: chronicController,
                                        decoration: const InputDecoration(
                                            hintText: "Any chronic disease"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Drugs',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextField(
                                        controller: drugs,
                                        decoration: const InputDecoration(
                                            hintText: "Drugs"),
                                        enabled: !_status,
                                      ),
                                    ),
                                  ],
                                )),
                            !_status ? _getActionButtons() : new Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  setState(() {
                    chronic != false
                        ? chronic = chronicController.text
                        : chronic = false;
                    diabetes != false
                        ? diabetes = diabetesController.text
                        : diabetes = false;
                    bloodPresure != false
                        ? bloodPresure = bloodPresureController.text
                        : bloodPresure = false;
                    heardDisease != false
                        ? heardDisease = heardDiseaseController.text
                        : heardDisease = false;
                    infectious != false
                        ? infectious = infectiousController.text
                        : infectious = false;
                  });
                  updateData();
                  setState(() {
                    _status = true;
                    dropDownStatus = false;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
          dropDownStatus = false;
        });
      },
    );
  }
}
