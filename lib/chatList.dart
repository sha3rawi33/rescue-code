import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rescue_code/chatRoom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  distance(double lat1, double lon1, lat2, lon2, unit) {
    var radlat1 = pi * lat1 / 180;
    var radlat2 = pi * lat2 / 180;
    var theta = lon1 - lon2;
    var radtheta = pi * theta / 180;
    var dist = sin(radlat1) * sin(radlat2) +
        cos(radlat1) * cos(radlat2) * cos(radtheta);
    dist = acos(dist);
    dist = dist * 180 / pi;
    dist = dist * 60 * 1.1515;
    if (unit == "K") {
      dist = dist * 1.609344;
    }
    if (unit == "N") {
      dist = dist * 0.8684;
    }
    return dist;
  }

  List doctors;
  void getDoctors() async {
    Position myLoc = await Geolocator().getCurrentPosition();

    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    List<DocumentSnapshot> list =
        querySnapshot.documents.where((p) => p['type'] != 'user').toList();
     var data = list.where((data) {
      var d = distance(myLoc.latitude, myLoc.longitude,
          double.parse(data.data['lat']), double.parse(data.data['lng']), "K");
      if (6 > d) {
        return true;
      } else {
        return false;
      }
    }).toList();
    setState(() {
      doctors = data;
    });
  }

  Future<dynamic> startChatRoom(
      String userUID, String doctorUID, String doctorName,String firebaseToken) async {
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
                    firebaseToken: firebaseToken,
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
        "doctors": FieldValue.arrayUnion([doctorRef])
      });
      DocumentSnapshot chatroomSnapshot = await reference.get();
      print(chatroomSnapshot.data);
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
        title: Text('Hospitals'),
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
              subtitle: Text(doctors[i]['government'] ?? ""),
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
                      doctors[i]['name'],
                      doctors[i]['firebaseToken']
                      );
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
