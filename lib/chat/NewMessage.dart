import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();
  String username;

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;

    try {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      FirebaseFirestore.instance.collection('chats').add({
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        'username': userData.get('username'),
        'admin': userData.get('admin'),
      });
      _controller.clear();
      _enteredMessage = "";
    } catch (e) {
      print("Came here");
      FirebaseAuth.instance.signOut();
      Navigator.pushNamed(context, 'SignUpLoginScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 8),
      child: Row(
        children: <Widget>[
          Expanded(
              child: TextField(
            style: TextStyle(
              fontSize: 20,
            ),
            textCapitalization: TextCapitalization.sentences,
            enableSuggestions: true,
            controller: _controller,
            cursorColor: Colors.deepPurple,
            decoration: InputDecoration(
              hintText: 'Send a message ...',
            ),
            onChanged: (value) {
              setState(() {
                _enteredMessage = value;
              });
            },
          )),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.deepPurple,
              size: 40.0,
            ),
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
