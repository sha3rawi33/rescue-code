import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rescue_code/doctorChatRoom.dart';
import 'package:shared_preferences/shared_preferences.dart';


class DoctorChat extends StatefulWidget {
  @override
  _DoctorChatState createState() => _DoctorChatState();
}

class _DoctorChatState extends State<DoctorChat> {
  List<dynamic> users;
  void getUsers() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    DocumentReference reference = Firestore.instance
        .collection("users")
        .document(_prefs.getString('uid'));
    // print(reference.path);
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

  Future<dynamic> startChatRoom(
      String userUID, String doctorUID, String userName) async {
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
                  )));
    }
  }

  @override
  void initState() {
    super.initState();
    getUsers();
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
              await prefs.remove("type");

              Navigator.pushReplacementNamed(context, 'boarding');
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
              onPressed: ()async {
                    SharedPreferences _prefs = await SharedPreferences.getInstance();

                startChatRoom(users[i]['token'], _prefs.getString('uid'), users[i]['name']);
              },
              icon: Icon(
                Icons.chat,
                color: Colors.red,
              ),
            ),
            title: Text(users[i]['name']),
            subtitle: Text(users[i]['government']),
          );
        },
      ),
    );
  }
}
