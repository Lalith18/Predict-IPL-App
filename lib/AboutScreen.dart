import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/Constants.dart';
import 'package:predict_ipl/widgets/ReusableCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  var _enteredMessage = '';
  final _controller = new TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    FirebaseFirestore.instance.collection('bug').add({
      'issue': _enteredMessage,
      'username': userData.get('username'),
    });
    _controller.clear();
    _enteredMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'About',
            style: headingStyle,
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.deepPurple),
        ),
        backgroundColor: Colors.deepPurple,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ReusableCard(
                  onTap: () {},
                  cardChild: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Text(
                            'DEVELOPER',
                            style: headingStyle,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ClipRRect(
                            child: Image.asset(
                              'images/lalith1.jpg',
                              height: 100,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          Text(
                            'LALITH K',
                            style: headingStyle,
                          ),
                          Text(
                            'For projects or collaborations contact:',
                            style: TextStyle(color: Colors.black, fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            'Email: leftoverdeveloper1@gmail.com',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  )),
              ReusableCard(
                  onTap: () {},
                  cardChild: Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              'ADMIN',
                              style: headingStyle,
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  child: Image.asset(
                                    'images/ramasamy.jpg',
                                    height: 100,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '  RAMASAMY',
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '  System analyst \n  App Designer',
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 20),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              children: [
                                ClipRRect(
                                  child: Image.asset(
                                    'images/harish.jpg',
                                    height: 100,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'HARISH SHANKAR',
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'App strategist \nUX specialist',
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 20),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ))),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white),
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Text(
                      'REPORT A BUG',
                      style: headingStyle,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: TextField(
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          textCapitalization: TextCapitalization.sentences,
                          controller: _controller,
                          enableSuggestions: true,
                          cursorColor: Colors.deepPurple,
                          decoration: InputDecoration(
                            hintText: 'Explain the issue',
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
                          onPressed: _enteredMessage.trim().isEmpty
                              ? null
                              : _sendMessage,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              ReusableCard(
                onTap: () {},
                cardChild: Padding(
                  padding: EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ABOUT APP',
                          style: headingStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'VERSION:               1.3.0 \nSDK:                          FLUTTER \nDATABASE:            FIREBASE',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
