import 'package:flutter/material.dart';

class ChatMessageListItem extends StatefulWidget {
  final name;
  final author;
  final userUID;
  final String value;
  final String profileImage;
  final type;
  final lat;
  final lng;
  ChatMessageListItem(
      {this.name,
      this.author,
      this.userUID,
      this.value,
      this.profileImage,
      this.type,
      this.lat,
      this.lng});

  @override
  _ChatMessageListItemState createState() => _ChatMessageListItemState();
}

class _ChatMessageListItemState extends State<ChatMessageListItem> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        children: widget.author == widget.userUID
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
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              widget.lat == ''
                  ? Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.all(4),
                      child: new Text(widget.value,
                          style: new TextStyle(
                            fontSize: 19.5,
                            color: Colors.white,
                          )),
                    )
                  : Container(
                      decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(10)),
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 3,
                      padding: EdgeInsets.all(4),
                      child: new Text(widget.lat.toString() + ", " + widget.lng.toString(),
                          style: new TextStyle(
                            fontSize: 19.5,
                            color: Colors.white,
                          )),
                    ),
              SizedBox(
                width: 5,
              ),
              if (widget.type == 'user') ...[
                new CircleAvatar(
                  backgroundImage: widget.profileImage == null
                      ? new ExactAssetImage('assets/profilepic.png')
                      : NetworkImage(widget.profileImage),
                  radius: 17,
                )
              ] else ...[
                new CircleAvatar(
                  backgroundImage: new ExactAssetImage('assets/profilepic.png'),
                  radius: 17,
                )
              ]
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
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              if (widget.type != 'user') ...[
                new CircleAvatar(
                  backgroundImage: widget.profileImage == null
                      ? new ExactAssetImage('assets/profilepic.png')
                      : NetworkImage(widget.profileImage),
                  radius: 17,
                )
              ] else ...[
                new CircleAvatar(
                  backgroundImage: new ExactAssetImage('assets/profilepic.png'),
                  radius: 17,
                )
              ],
              SizedBox(
                width: 5,
              ),
              widget.lat == ""
                  ? Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(4),
                      child: new Text(
                        widget.value,
                        style: new TextStyle(
                          fontSize: 19.5,
                          color: Colors.white,
                        ),
                        maxLines: 99,
                        overflow: TextOverflow.ellipsis,
//                      textAlign: TextAlign.justify,
//                    textDirection: TextDirection.ltr,
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.width / 3,
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(4),
                      child: new Text(
                        widget.lat.toString() + ", " + widget.lng.toString(),
                        style: new TextStyle(
                          fontSize: 19.5,
                          color: Colors.white,
                        ),
                        maxLines: 99,
                        overflow: TextOverflow.ellipsis,
//                      textAlign: TextAlign.justify,
//                    textDirection: TextDirection.ltr,
                      ),
                    ),
            ],
          ),
        ),
      ),
    ];
  }
}
