import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rescue_code/doctorChatRoom.dart';
import 'package:rescue_code/userSearch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorChat extends StatefulWidget {
  @override
  _DoctorChatState createState() => _DoctorChatState();
}

class _DoctorChatState extends State<DoctorChat> {
  List<dynamic> users;

  initializeNotifications() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    await _firebaseMessaging.autoInitEnabled();

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
          .document(_prefs.getString('uid'))
          .updateData({"firebaseToken": token});
    });
  }

  void getUsers() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    DocumentReference reference = Firestore.instance
        .collection("users")
        .document(_prefs.getString('uid'));
    QuerySnapshot list =
        await Firestore.instance.collection("users").getDocuments();

    setState(() {
      users = list.documents.where((p) {
        if (p.data['doctors'] != null) {
          dynamic data = p.data['doctors'];
          var isTrue = data.contains(reference);

          return isTrue;
        } else {
          return false;
        }
      }).toList();
    });
  }

  Future<dynamic> startChatRoom(String userUID, String doctorUID,
      String userName, String firebaseToken) async {
    DocumentReference userRef =
        Firestore.instance.collection("users").document(doctorUID);
    QuerySnapshot queryResults = await Firestore.instance
        .collection("chats")
        .where("participants", arrayContains: userRef)
        .getDocuments();
    DocumentReference doctorRef =
        Firestore.instance.collection("users").document(userUID);
    DocumentSnapshot roomSnapshot = queryResults.documents.firstWhere((room) {
      return room.data["participants"].contains(doctorRef);
    }, orElse: () => null);
    if (roomSnapshot != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DoctorChatRoom(
                    userUID: userUID,
                    chatId: roomSnapshot.documentID,
                    doctorUID: doctorUID,
                    name: userName,
                    type: 'doctor',
                    firebaseToken: firebaseToken,
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
    initializeNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.remove("uid");
              final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

              _firebaseMessaging.deleteInstanceID();

              Navigator.pushReplacementNamed(context, 'welcome');
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => UserSearch()));
            },
          )
        ],
        title: Text('Users'),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
        itemCount: users == null ? 0 : users.length,
        itemBuilder: (context, i) {
          return ListTile(
            trailing: IconButton(
              onPressed: () async {
                SharedPreferences _prefs =
                    await SharedPreferences.getInstance();

                startChatRoom(users[i]['token'], _prefs.getString('uid'),
                    users[i]['name'], users[i]['firebaseToken']);
              },
              icon: Icon(
                Icons.chat,
                color: Colors.red,
              ),
            ),
            title: Text(users[i]['name']),
            subtitle: Text(users[i]['government'] ?? ''),
          );
        },
      ),
    );
  }
}
