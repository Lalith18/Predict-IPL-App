import 'package:flutter/material.dart';
import 'file:///C:/Users/lalith%20k/AndroidStudioProjects/predict_ipl/lib/chat/GroupChat.dart';
import 'file:///C:/Users/lalith%20k/AndroidStudioProjects/predict_ipl/lib/chat/NewMessage.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text('LOBBY',
            style: TextStyle(
                color: Colors.white,
                fontSize: 35,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: GroupChat(),
            ),
            NewMessage()
          ],
        ),
      ),
    );
  }
}
