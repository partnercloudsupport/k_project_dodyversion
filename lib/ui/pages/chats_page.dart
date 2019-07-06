import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:k_project_dodyversion/resources/repository.dart';
import 'package:k_project_dodyversion/ui/themes/theme.dart';
import 'package:k_project_dodyversion/utils/utils.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

class ChatConstant {
  static const String SENDER_TAG = "senderID";
  static const String RECIPIENT_TAG = "recipientID";
  static const String TIMESTAMP_TAG = "timestamp";
  // image gonnabe url, messages gonna be strings
  static const String CONTENT_TAG = "content";
  static const String TYPE_TAG = "type";
}

class ChatsPage extends StatefulWidget {
  final String peerID;
  final String peerName;
  final String peerProfilePicture;
  ChatsPage(this.peerID, this.peerName, this.peerProfilePicture, {Key key})
      : super(key: key);

  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  var greyColor = Colors.grey;
  var greyColor2 = Colors.grey;
  var themeColor = Colors.red;
  var listMessage;
  int messageCount = 20;
  var peerAvatar;
  String groupChatID;
  var id = UserRepository.mUser.uid;
  final ScrollController listScrollController = new ScrollController();
  final TextEditingController textEditingController =
      new TextEditingController();

  var isLoading;

  @override
  void initState() {
    super.initState();
    List members;
    List membersName;
    List membersProfilePicture;
    peerAvatar = widget.peerProfilePicture;
    // _refreshController = RefreshController(initialRefresh: true);
    if (id.hashCode <= widget.peerID.hashCode) {
      groupChatID = '$id-${widget.peerID}';
      members = [id, widget.peerID];
      membersName = [UserRepository.mUser.name, widget.peerName];
      membersProfilePicture = [
        UserRepository.mUser.profilePictureURL,
        widget.peerProfilePicture
      ];
    } else {
      groupChatID = '${widget.peerID}-$id';
      members = [widget.peerID, id];
      membersName = [widget.peerName, UserRepository.mUser.name];
      membersProfilePicture = [
        widget.peerProfilePicture,
        UserRepository.mUser.profilePictureURL
      ];
    }
    isLoading = true;

    Firestore.instance
        .collection('chatrooms')
        .document(groupChatID)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        Firestore.instance
            .collection('chatrooms')
            .document(groupChatID)
            .updateData({
          'members': members,
          'names': membersName,
          'membersProfilePicture': membersProfilePicture,
        }).then((onValue) {
          setState(() {
            isLoading = false;
          });
        });
      } else {
        Firestore.instance
            .collection('chatrooms')
            .document(groupChatID)
            .setData({
          'lastMessage': 'asdfasdf',
          'members': members,
          'names': membersName,
          'membersProfilePicture': membersProfilePicture,
        }).then((onValue) {
          setState(() {
            isLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.peerName),
      ),
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
      // onRefresh: () async {
      //   setState(() {
      //     messageCount += 2;
      //   });
      //   _refreshController.loadComplete();
      //   return null;
      // },
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatID == ''
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('chatrooms')
                  .document(groupChatID)
                  .collection('messages')
                  .orderBy(ChatConstant.TIMESTAMP_TAG, descending: true)
                  .limit(messageCount)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  listMessage = snapshot.data.documents;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemBuilder: (context, index) =>
                        buildItem(index, snapshot.data.documents[index]),
                    itemCount: snapshot.data.documents.length,
                    reverse: true,
                    controller: listScrollController,
                  );
                }
              },
            ),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: () {}, //getImage,
                color: KProjectTheme.PRIMARY_COLOR,
              ),
            ),
            color: Colors.white,
          ),
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                    color: KProjectTheme.PRIMARY_COLOR, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor),
                ),
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, 0),
                color: KProjectTheme.PRIMARY_COLOR,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
              child: Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
              ),
              color: Colors.white.withOpacity(0.8),
            )
          : Container(),
    );
  }

  Future<bool> onBackPress() {
    Navigator.pop(context);

    return Future.value(false);
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1][ChatConstant.SENDER_TAG] ==
                UserRepository.mUser.uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
            listMessage != null &&
            listMessage[index - 1][ChatConstant.SENDER_TAG] !=
                UserRepository.mUser.uid) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  void onSendMessage(String content, int type) {
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.trim() != '') {
      textEditingController.clear();

      var documentReference = Firestore.instance
          .collection('chatrooms')
          .document(groupChatID)
          .collection('messages')
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      var documentRefer2 =
          Firestore.instance.collection('chatrooms').document(groupChatID);
      Firestore.instance.runTransaction((transaction) async {
        // Update the message document
        await transaction.set(
          documentReference,
          {
            ChatConstant.SENDER_TAG: id,
            ChatConstant.RECIPIENT_TAG: widget.peerID,
            ChatConstant.TIMESTAMP_TAG:
                DateTime.now().millisecondsSinceEpoch.toString(),
            ChatConstant.CONTENT_TAG: content,
            ChatConstant.TYPE_TAG: type
          },
        );
        // Update the last message for quick retrival
        await transaction.update(documentRefer2, {
          'lastMessage': content,
        });
      });
      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      NotificationUtils.showMessage("nothing to send", _scaffoldKey);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document[ChatConstant.SENDER_TAG] == id) {
      // Right (my message)
      return Row(
        children: <Widget>[
          document[ChatConstant.TYPE_TAG] == 0
              // Text
              ? Container(
                  child: Text(
                    document[ChatConstant.CONTENT_TAG],
                    style: TextStyle(color: KProjectTheme.PRIMARY_COLOR),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: KProjectTheme.PRIMARY_COLOR,
                        width: 1,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0)),
                  margin: EdgeInsets.only(
                      bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                      right: 10.0),
                )
              : document[ChatConstant.TYPE_TAG] == 1
                  // Image
                  ? Container(
                      child: Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(themeColor),
                                ),
                                width: 200.0,
                                height: 200.0,
                                padding: EdgeInsets.all(70.0),
                                decoration: BoxDecoration(
                                  color: greyColor2,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) => Material(
                                child: Image.asset(
                                  'images/img_not_available.jpeg',
                                  width: 200.0,
                                  height: 200.0,
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8.0),
                                ),
                                clipBehavior: Clip.hardEdge,
                              ),
                          imageUrl: document[ChatConstant.CONTENT_TAG],
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    )
                  // Sticker
                  : Container(
                      child: new Image.asset(
                        'images/${document[ChatConstant.CONTENT_TAG]}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                          right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMessageLeft(index)
                    ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.0,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(themeColor),
                                ),
                                width: 35.0,
                                height: 35.0,
                                padding: EdgeInsets.all(10.0),
                              ),
                          imageUrl: peerAvatar,
                          width: 35.0,
                          height: 35.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.0),
                        ),
                        clipBehavior: Clip.hardEdge,
                      )
                    : Container(width: 35.0),
                document[ChatConstant.TYPE_TAG] == 0
                    ? Container(
                        child: Text(
                          document[ChatConstant.CONTENT_TAG],
                          style: TextStyle(color: Colors.white),
                        ),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        width: 200.0,
                        decoration: BoxDecoration(
                            color: KProjectTheme.PRIMARY_COLOR,
                            borderRadius: BorderRadius.circular(8.0)),
                        margin: EdgeInsets.only(left: 10.0),
                      )
                    : document[ChatConstant.TYPE_TAG] == 1
                        ? Container(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                themeColor),
                                      ),
                                      width: 200.0,
                                      height: 200.0,
                                      padding: EdgeInsets.all(70.0),
                                      decoration: BoxDecoration(
                                        color: greyColor2,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, url, error) => Material(
                                      child: Image.asset(
                                        'images/img_not_available.jpeg',
                                        width: 200.0,
                                        height: 200.0,
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      ),
                                      clipBehavior: Clip.hardEdge,
                                    ),
                                imageUrl: document[ChatConstant.CONTENT_TAG],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            margin: EdgeInsets.only(left: 10.0),
                          )
                        : Container(
                            child: new Image.asset(
                              'images/${document[ChatConstant.CONTENT_TAG]}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: isLastMessageRight(index) ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            isLastMessageLeft(index)
                ? Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document[ChatConstant.TIMESTAMP_TAG]))),
                      style: TextStyle(
                          color: greyColor,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}
