import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {

  List doctors;
  void getDoctors() async {
    QuerySnapshot querySnapshot =
        await Firestore.instance.collection("users").getDocuments();
    var list = querySnapshot.documents.where((p)=> p['type'] != 'user').toList();
    print(list);
    setState(() {
      doctors = list;
    });
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
          return Column(
            
                      children: [ListTile(
              title: Text(doctors[i]['name']),
              subtitle: Text(doctors[i]['government']),
              onTap: (){},
              trailing: IconButton(
                icon: Icon(Icons.chat,
                color: Colors.red,),
                onPressed: (){},
              ),
            ),

            Divider()]
          );
        },
      ),
    );
  }
}
