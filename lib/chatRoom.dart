import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rescue_code/style/chatRoomItems.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  final String chatId;
  final userUID;
  final String name;
  final type;
  final firebaseToken;
  ChatRoom(
      {@required this.chatId,
      @required this.userUID,
      @required this.name,
      this.type = 'user',
      this.firebaseToken});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final String serverToken = 'AIzaSyAiPEZR_LRpHZqvBmPHNdtHK0RWQw_IRgY';
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Timer timer;
  List messages;
  bool _isComposingMessage = false;
  TextEditingController messageController = TextEditingController();
  final textController = TextEditingController();
  var lat;
  var lng;

  _alertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return BeautifulAlertDialog();
        });
  }

  checkNsend() {
    String msg;
    msg = messageController.text.trim();

    // Checking TextField.
    if (msg.isEmpty) {
      print('✖ Message wasn\'t sent ✖');
      scrollToEnd();
      _alertDialog(context);
    } else if (msg.isNotEmpty && msg != "") {
      print("Message was sent ✅");
      scrollToEnd();
      sendMessage(msg);
      _isComposingMessage = false;
    }
  }

  var profileImage;

  getImage() async {
    try {
      StorageReference reference =
          FirebaseStorage.instance.ref().child("images/${widget.userUID}.png");
      var url = await reference.getDownloadURL();
      setState(() {
        profileImage = url;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage(
      String title, String body) async {
    await firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );

    await post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'body': body, 'title': title},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          'to': widget.firebaseToken,
        },
      ),
    ).then((res) {
      print(widget.firebaseToken);
      print(res.body);
    });

    final Completer<Map<String, dynamic>> completer =
        Completer<Map<String, dynamic>>();

    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        completer.complete(message);
      },
    );
    messageController.clear();

    return completer.future;
  }

  Future<bool> sendMessage(String message) async {
    //  if (message.trim() != '') {

    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();

      DocumentReference authorRef =
          Firestore.instance.collection("users").document(widget.userUID);
      DocumentReference chatroomRef =
          Firestore.instance.collection("chats").document(widget.chatId);
      Map<String, dynamic> serializedMessage = {
        "name": _prefs.getString('name'),
        "author": authorRef,
        "timestamp": DateTime.now(),
        "value": message,
        "lat": "",
        "lng": ""
      };
      await chatroomRef.updateData({
        "messages": FieldValue.arrayUnion([serializedMessage])
      });
      sendAndRetrieveMessage(_prefs.getString('name'), message);
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> sendLocation(String lat, String lng) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();

      DocumentReference authorRef =
          Firestore.instance.collection("users").document(widget.userUID);
      DocumentReference chatroomRef =
          Firestore.instance.collection("chats").document(widget.chatId);
      Map<String, dynamic> serializedMessage = {
        "name": _prefs.getString('name'),
        "author": authorRef,
        "timestamp": DateTime.now(),
        "value": '',
        "lat": lat.toString(),
        "lng": lng.toString()
      };
      await chatroomRef.updateData({
        "messages": FieldValue.arrayUnion([serializedMessage])
      });
      messageController.clear();
      return true;
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  void getMessages() async {
    var res = await Firestore.instance
        .collection("chats")
        .document(widget.chatId)
        .get();
    setState(() {
      messages = res.data['messages'];
    });
  }

  ScrollController _scrollController = ScrollController();

  scrollToEnd() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        timer = t;
      });
      getMessages();
    });
    getImage();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future getLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    setState(() {
      lat = position.latitude.toString();
      lng = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.red,
        ),
        body: Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                  child: ListView.builder(
                controller: _scrollController,
                itemCount: messages == null ? 0 : messages.length,
                itemBuilder: (context, i) {
                  return ChatMessageListItem(
                      author: messages[i]['author'],
                      userUID: Firestore.instance
                          .collection("users")
                          .document(widget.userUID),
                      name: messages[i]['name'],
                      value: messages[i]['value'],
                      profileImage: profileImage,
                      lat: messages[i]['lat'] ?? '',
                      lng: messages[i]['lng'] ?? '',
                      type: 'user');
                },
              )),
              new Divider(height: 1.0),
              new Container(
                decoration:
                    new BoxDecoration(color: Theme.of(context).cardColor),
                child: _buildTextComposer(),
              ),
              new Builder(builder: (BuildContext context) {
                return new Container(width: 0.0, height: 0.0);
              })
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS
              ? new BoxDecoration(
                  border: new Border(
                      top: new BorderSide(
                  color: Colors.grey[200],
                )))
              : null,
        ));
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(Icons.send),
      onPressed: _isComposingMessage ? () => checkNsend() : null,
    );
  }

  IconButton getLocationSendButton() {
    return new IconButton(
      icon: new Icon(Icons.add_location),
      onPressed: () async {
        await getLocation();
        await sendLocation(lat, lng);
      },
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isComposingMessage
              ? Colors.red
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  controller: messageController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isComposingMessage = messageText.length > 0;
                    });
                  },
                  onSubmitted: (message) => checkNsend(),
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getLocationSendButton(),
              ),
            ],
          ),
        ));
  }
}

class BeautifulAlertDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(right: 16.0),
          height: 150,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(75),
                  bottomLeft: Radius.circular(75),
                  topRight: Radius.circular(10),
                  bottomRight: Radius.circular(10))),
          child: Row(
            children: <Widget>[
              SizedBox(width: 20.0),
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey.shade200,
                child: Center(
                    child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 110,
                )),
              ),
              SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Wasn't sent!",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10.0),
                    Flexible(
                      child: Text(
                        "- Message Can't Be Empty",
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
//                      Expanded(
//                        child: RaisedButton(
//                          child: Text("No"),
//                          color: Colors.red,
//                          colorBrightness: Brightness.dark,
//                          onPressed: (){Navigator.pop(context);},
//                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//                        ),
//                      ),
                        SizedBox(width: 10.0),
                        Expanded(
                          child: RaisedButton(
                            child: Text(
                              "Ok",
                              style: TextStyle(fontSize: 20),
                            ),
                            color: Colors.green,
                            colorBrightness: Brightness.dark,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
