import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSearch extends StatefulWidget {
  @override
  _UserSearchState createState() => _UserSearchState();
}

class _UserSearchState extends State<UserSearch> {
  TextEditingController _searchController = TextEditingController();
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
  bool diabetes = false;
  bool bloodPresure = false;
  bool heardDisease = false;
  bool infectious = false;
  bool chronic = false;

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
    QuerySnapshot user =
        await Firestore.instance.collection('users').getDocuments();

    SharedPreferences _prefs = await SharedPreferences.getInstance();

    List<DocumentSnapshot> data =
        user.documents.where((p) => p['id'] == _searchController.text).toList();
    if (data.isEmpty) {
      name = TextEditingController();
      _searchController.clear();
    } else {
      Map result = data[0].data;

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
      try {
        final ref = FirebaseStorage.instance
            .ref()
            .child('images/${result['token']}.png');
        var url = await ref.getDownloadURL();
        setState(() {
          profileImage = url;
        });
      } catch (e) {
        print(e);
      }
      setState(() {});
      _searchController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new TextField(
            cursorColor: Colors.white,
            controller: _searchController,
            style: new TextStyle(
              color: Colors.white,
            ),
            keyboardType: TextInputType.number,
            decoration: new InputDecoration(
              border: InputBorder.none,
                hintText: "Search...",
                hintStyle: new TextStyle(color: Colors.white)),
          ),
          backgroundColor: Colors.red,
          actions: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.search),
              ),
              onTap: () {
                if (_searchController.text != '') {
                  getData();
                }
              },
            ),
          ],
        ),
        body: name.text == ''
            ? Center(
                child: Text("You can search any user by id")
              )
            : SafeArea(
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
                                  child:
                                      new Stack(fit: StackFit.loose, children: <
                                          Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                        : NetworkImage(
                                                            profileImage),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 90.0, right: 100.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                                // upload();
                                              }, // Image Picker
                                            )
                                          ],
                                        )),
                                  ]),
                                ),
                                Padding(
                                    padding:
                                        EdgeInsets.only(top: 10.0, right: 0.0),
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
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              // _status
                                              //     ? _getEditIcon()
                                              //     : new Container(),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  hintText:
                                                      "Enter Email Address"),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  hintText:
                                                      "Enter Mobile Number"),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  hintText:
                                                      "Enter National ID"),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                'Age',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Flexible(
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              child: new TextField(
                                                controller: age,
                                                decoration:
                                                    const InputDecoration(
                                                        hintText:
                                                            "Enter Your Age"),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                  hintText:
                                                      "Enter your Address"),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              child: new Text(
                                                'Gender',
                                                style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.0),
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
                                              padding:
                                                  EdgeInsets.only(right: 10.0),
                                              child: new DropdownButton(
                                                disabledHint: Center(
                                                    child: Text("Blood Type")),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            child: Checkbox(
                                              value: diabetes,
                                              activeColor: Colors.red,
                                              onChanged: !_status
                                                  ? (value) {
                                                      setState(() {
                                                        diabetes = value;
                                                      });
                                                    }
                                                  : (s) {},
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            child: Checkbox(
                                              value: bloodPresure,
                                              activeColor: Colors.red,
                                              onChanged: !_status
                                                  ? (value) {
                                                      setState(() {
                                                        bloodPresure = value;
                                                      });
                                                    }
                                                  : (s) {},
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            child: Checkbox(
                                              activeColor: Colors.red,
                                              value: heardDisease,
                                              onChanged: !_status
                                                  ? (value) {
                                                      setState(() {
                                                        heardDisease = value;
                                                      });
                                                    }
                                                  : (s) {},
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            child: Checkbox(
                                              activeColor: Colors.red,
                                              value: infectious,
                                              onChanged: !_status
                                                  ? (value) {
                                                      setState(() {
                                                        infectious = value;
                                                      });
                                                    }
                                                  : (s) {},
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                            child: Checkbox(
                                              activeColor: Colors.red,
                                              value: chronic,
                                              onChanged: !_status
                                                  ? (value) {
                                                      setState(() {
                                                        chronic = value;
                                                      });
                                                    }
                                                  : (s) {},
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                  //  !_status ? _getActionButtons() : new Container(),
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
}
