import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:predict_ipl/AdminScreen.dart';
import 'file:///C:/Users/lalith%20k/AndroidStudioProjects/predict_ipl/lib/chat/ChatScreen.dart';
import 'package:predict_ipl/HomeScreen.dart';
import 'package:predict_ipl/Profile.dart';
import 'package:predict_ipl/PredictScreen.dart';
import 'package:predict_ipl/InputAns.dart';
import 'package:predict_ipl/LeaderBoardScreen.dart';
import 'package:predict_ipl/AboutScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:predict_ipl/authentication/SignUpLoginScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  bool _isEMailVerified() {
    if (FirebaseAuth.instance.currentUser != null) {
      return FirebaseAuth.instance.currentUser.emailVerified;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Ubuntu',
        ),
        routes: {
          'SignUpLoginScreen': (context) => SignUpLoginScreen(),
          'ChatScreen': (context) => ChatScreen(),
          'HomeScreen': (context) => HomeScreen(),
          'ProfileScreen': (context) => ProfileScreen(),
          'PredictScreen': (context) => PredictScreen(),
          'AdminScreen': (context) => AdminScreen(),
          'AnsScreen': (context) => AnsScreen(),
          'LeaderBoardScreen': (context) => LeaderBoard(),
          'AboutScreen': (context) => AboutScreen(),
        },
        home: FutureBuilder(
            future: Firebase.initializeApp(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return (FirebaseAuth.instance.currentUser != null &&
                        _isEMailVerified())
                    ? HomeScreen()
                    : SignUpLoginScreen();
              }

              // Otherwise, show something whilst waiting for initialization to complete
              return CircularProgressIndicator();
            }));
  }
}
