import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rescue_code/style/chatRoomItems.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorChatRoom extends StatefulWidget {
  final String chatId;
  final doctorUID;
  final userUID;
  final String name;
  final type;
  DoctorChatRoom(
      {@required this.chatId,
      @required this.doctorUID,
      @required this.name,
      this.userUID,
      this.type = 'user'});
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<DoctorChatRoom> {
  Timer timer;
  List messages;
  bool _isComposingMessage = false;
  TextEditingController messageController = TextEditingController();

  checkNsend(){
    String msg;

    msg = messageController.text ;

    // Checking all TextFields.
    if(msg.isEmpty || msg.length<2)
    {
      // Put your code here which you want to execute when Text Field is Empty.
      print('Text Field is empty, Please Fill All Data');


    }else if (msg.isNotEmpty){
      print("Text Field is full");
      sendMessage(msg);
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

  Future<bool> sendMessage(String message) async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();

      DocumentReference authorRef =
          Firestore.instance.collection("users").document(widget.doctorUID);
      DocumentReference chatroomRef =
          Firestore.instance.collection("chats").document(widget.chatId);
      Map<String, dynamic> serializedMessage = {
        "name": _prefs.getString('name'),
        "author": authorRef,
        "timestamp": DateTime.now(),
        "value": message
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
                itemCount: messages == null ? 0 : messages.length,
                itemBuilder: (context, i) {
                  return ChatMessageListItem(
                      author: messages[i]['author'],
                      userUID: Firestore.instance
                          .collection("users")
                          .document(widget.doctorUID),
                      name: messages[i]['name'],
                      value: messages[i]['value'],
                     profileImage: profileImage,
                      type: widget.type);
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
      onPressed: _isComposingMessage
          ? () => checkNsend()
          : null,
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
                  onSubmitted: (message) => _isComposingMessage = false,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }
}
