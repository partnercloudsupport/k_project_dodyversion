import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/pages/pages.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';

class ChatroomsPage extends StatefulWidget {
  ChatroomsPage({Key key}) : super(key: key);

  _ChatroomsPageState createState() => _ChatroomsPageState();
}

class _ChatroomsPageState extends State<ChatroomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chats"),
      ),
      body: StreamBuilder(
        stream: Firestore.instance
            .collection('chatrooms')
            .where('members', arrayContains: UserRepository.mUser.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        KProjectTheme.PRIMARY_COLOR)));
          } else {
            // listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(var index, DocumentSnapshot document) {
    String peerName;

    if (document.data['members'][0] == UserRepository.mUser.uid) {
      peerName = document.data['names'][1];
    } else {
      peerName = document.data['names'][0];
    }
    return GestureDetector(
      child: Card(
        child: Column(
          children: <Widget>[
            Text(peerName),
            Text(document.data['lastMessage']),
          ],
        ),
      ),
      onTap: () {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) {
            if (document.data['members'][0] == UserRepository.mUser.uid) {
              return ChatsPage(
                  document.data['members'][1],
                  document.data['names'][1],
                  document.data['membersProfilePicture'][1]);
              // document.data['members'][1]);
            }
            // return ChatsPage(document.data['members'][0]);
            return ChatsPage(
                document.data['members'][0],
                document.data['names'][0],
                document.data['membersProfilePicture'][0]);
          },
        );
        Navigator.of(context).push(route);
      },
    );
  }
}
