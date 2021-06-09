import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bubble extends StatelessWidget {
  Bubble(this.username, this.message, this.isMe, this.isAdmin, this.admin,
      this.key, this.documentId);
  final String message, username;
  final bool isMe;
  final bool admin;
  final bool isAdmin;
  final Key key;
  final String documentId;

  void removeChat(String documentId) async {
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(documentId)
        .delete();
  }

  void removeUser(String documentId) async {
    final userData = await FirebaseFirestore.instance
        .collection('chats')
        .doc(documentId)
        .get();
    String id = userData.get('userId');
    if (userData != null) {
      await FirebaseFirestore.instance.collection('users').doc(id).delete();
      removeChat(documentId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: isAdmin
          ? () {
              removeChat(documentId);
            }
          : () {},
      onLongPress: isAdmin
          ? () {
              removeUser(documentId);
            }
          : () {},
      child: Row(
        mainAxisAlignment: admin
            ? MainAxisAlignment.center
            : isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                color: admin
                    ? Colors.red
                    : isMe ? Colors.deepPurple : Colors.pinkAccent,
                borderRadius: admin
                    ? BorderRadius.all(Radius.circular(15.0))
                    : isMe
                        ? BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(15.0),
                            bottomRight: Radius.circular(15.0),
                            bottomLeft: Radius.circular(15.0)),
              ),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Column(
                crossAxisAlignment: admin
                    ? CrossAxisAlignment.center
                    : isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    username,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    message,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    textAlign: admin
                        ? TextAlign.center
                        : isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
