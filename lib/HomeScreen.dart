import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/ReusableCard.dart';
import 'package:predict_ipl/widgets/Constants.dart';
import 'package:predict_ipl/widgets/MainDrawer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'team/TeamData.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (msg) {
        print(msg);
        return;
      },
      onResume: (msg) {
        print(msg);
        return;
      },
      onLaunch: (msg) {
        print(msg);
        return;
      },
    );
    fbm.subscribeToTopic('chats');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      drawer: MainDrawer(),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.deepPurple),
        title: Text(
          'HOME',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.deepPurple,
              fontSize: 35,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            height: 60,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  Teams[0].imageAddress,
                ),
                Image.asset(
                  Teams[3].imageAddress,
                ),
                Image.asset(
                  Teams[6].imageAddress,
                ),
                Image.asset(
                  Teams[4].imageAddress,
                ),
              ],
            ),
          ),
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: ReusableCard(
                cardChild: Center(
                  child: Text(
                    'PREDICT',
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'PredictScreen');
                },
              )),
              Expanded(
                  child: ReusableCard(
                cardChild: Center(
                  child: Text(
                    'LEADER BOARD',
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'LeaderBoardScreen');
                },
              )),
            ],
          )),
          Expanded(
              child: Row(
            children: [
              Expanded(
                  child: ReusableCard(
                cardChild: Center(
                  child: Text(
                    'LOBBY',
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'ChatScreen');
                },
              )),
              Expanded(
                  child: ReusableCard(
                cardChild: Center(
                  child: Text(
                    'PROFILE',
                    style: headingStyle,
                    textAlign: TextAlign.center,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, 'ProfileScreen');
                },
              )),
            ],
          )),
          Container(
            padding: EdgeInsets.all(10),
            height: 60,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(
                  Teams[1].imageAddress,
                ),
                Image.asset(
                  Teams[2].imageAddress,
                ),
                Image.asset(
                  Teams[5].imageAddress,
                ),
                Image.asset(
                  Teams[7].imageAddress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
