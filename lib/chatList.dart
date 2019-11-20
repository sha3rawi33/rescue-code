import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rescue_code/chatRoom.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  List doctors;
  void getDoctors() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    var list =
        querySnapshot.documents.where((p) => p['type'] != 'user').toList();
    print(list);
    setState(() {
      doctors = list;
    });
  }

  Future<dynamic> startChatRoom(
      String userUID, String doctorUID, String doctorName) async {
    DocumentReference userRef =
        Firestore.instance.collection("users").document(userUID);
    QuerySnapshot queryResults = await Firestore.instance
        .collection("chats")
        .where("participants", arrayContains: userRef)
        .getDocuments();
    DocumentReference doctorRef =
         Firestore.instance.collection("users").document(doctorUID);
    DocumentSnapshot roomSnapshot = queryResults.documents.firstWhere((room) {
      return room.data["participants"].contains(doctorRef);
    }, orElse: () => null);
    if (roomSnapshot != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatRoom(
                    chatId: roomSnapshot.documentID,
                    userUID: userUID,
                    name: doctorName,

                  )));
    } else {
      Map<String, dynamic> chatroomMap = Map<String, dynamic>();
      chatroomMap["messages"] = List<String>(0);
      List<DocumentReference> participants = List<DocumentReference>(2);
      participants[0] = doctorRef;
      participants[1] = userRef;
      chatroomMap["participants"] = participants;
      DocumentReference reference =
          await Firestore.instance.collection("chats").add(chatroomMap);
      await Firestore.instance
          .collection("users")
          .document(userUID)
          .updateData({
            "doctors":FieldValue.arrayUnion([doctorRef])
          });
      DocumentSnapshot chatroomSnapshot = await reference.get();
      print(chatroomSnapshot.data);
      startChatRoom(userUID, doctorUID, doctorName);
    }
  }

  @override
  void initState() {
    super.initState();
    getDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: doctors == null ? 0 : doctors.length,
        cacheExtent: 0,
        padding: EdgeInsets.all(0),
        itemBuilder: (context, i) {
          return Column(children: [
            ListTile(
              title: Text(doctors[i]['name']),
              subtitle: Text(doctors[i]['government']??""),
              //  onTap: (){},
              trailing: IconButton(
                icon: Icon(
                  Icons.chat,
                  color: Colors.red,
                ),
                onPressed: () async {
                  SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  startChatRoom(_prefs.getString('uid'), doctors[i]['uid'],
                      doctors[i]['name']);
                },
              ),
            ),
            Divider()
          ]);
        },
      ),
    );
  }
}
