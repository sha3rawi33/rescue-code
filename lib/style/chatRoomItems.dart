import 'package:flutter/material.dart';


class ChatMessageListItem extends StatelessWidget {
  final name;
  final author;
  final userUID;
  final String value;
  ChatMessageListItem({this.name,this.author,this.userUID,this.value});

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        children: author == userUID
            ? getSentMessageLayout()
            : getReceivedMessageLayout(),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              new Text(name,
                  style: new TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              new Text(value,
                  style: new TextStyle(
                    fontSize: 19.5,
                    color: Colors.black,
                  )),
              Divider()
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(name,
                  style: new TextStyle(
                      fontSize: 17.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
              new Text(value,
                  style: new TextStyle(
                    fontSize: 19.5,
                    color: Colors.black,
                  )),
              Divider()
            ],
          ),
        ),
      ),
    ];
  }
}