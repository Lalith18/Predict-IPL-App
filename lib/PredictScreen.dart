import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/ReusableCard.dart';
import 'package:predict_ipl/widgets/Constants.dart';
import 'package:predict_ipl/team/TeamData.dart';
import 'package:predict_ipl/team/TeamClass.dart';
import 'package:predict_ipl/widgets/PinkButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'widgets/PlayerPicker.dart';

class PredictScreen extends StatefulWidget {
  @override
  _PredictScreenState createState() => _PredictScreenState();
}

enum TeamSelect {
  team1,
  team2,
}

enum TossSelect {
  bat,
  bowl,
}

class _PredictScreenState extends State<PredictScreen> {
  String teamChosen = 'team1', tossChosen = 'bat';
  var teamSelect = TeamSelect.team1;
  var tossSelect = TossSelect.bat;
  Team team1 = Teams[8];
  Team team2 = Teams[8];
  int matchNumber = 0;
  int runs = 150;
  int wickets = 4;
  String playerMOM = "Select player's team";
  bool _canPredict = false;
  User loggedInUser;
  var pointDoc;
  String username;
  int fifties = 0;

  final SnackBar snackBar = SnackBar(
    content: Text(
      'Time Up! You cannot predict.',
      style: TextStyle(fontSize: 20),
    ),
    duration: Duration(seconds: 2),
  );

  void getCurrentUser() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.uid)
            .get();
        username = userDoc.get('username');
        final QuerySnapshot result = await FirebaseFirestore.instance
            .collection('points')
            .where('email', isEqualTo: loggedInUser.email)
            .get();
        pointDoc = result.docs;
      }
    } catch (e) {
      print(e);
    }
  }

  void getMatch() async {
    final matchData = await FirebaseFirestore.instance
        .collection('new match')
        .doc('xNShtGFMSjCD0Nbg5avM')
        .get();
    final predictData = await FirebaseFirestore.instance
        .collection('canPredict')
        .doc('e2aOvl6xoTziNPMoXTZo')
        .get();
    setState(() {
      team1 = Teams[matchData.get('team1')];
      team2 = Teams[matchData.get('team2')];
      matchNumber = matchData.get('matchNumber');
      _canPredict = predictData.get('canPredict');
    });
  }

  @override
  void initState() {
    super.initState();
    getMatch();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'PREDICT',
          style: headingStyle,
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple),
        actions: [
          IconButton(
              icon: Icon(
                FontAwesomeIcons.question,
                size: 30,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Rules',
                          textAlign: TextAlign.center,
                        ),
                        content: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidDotCircle,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    'Choose the winning team.(It will be your chosen team for this match)',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidDotCircle,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    "Predict the toss winner's decision(bat/bowl).",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidDotCircle,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    "Predict your chosen team's total score.",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidDotCircle,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    "Predict number of wickets taken by your chosen team.",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidDotCircle,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    'Predict the Man of the Match by selecting his team to pick the player.',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FontAwesomeIcons.solidDotCircle,
                                  size: 25,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: Text(
                                    'Guess the total number of fifties we will encounter in this match (both teams included).',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    });
              })
        ],
      ),
      backgroundColor: Colors.deepPurple,
      body: Builder(
        builder: (ctx) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 10,
              ),
              Text(
                'WINNING TEAM',
                style: headingStyleWhite,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReusableCard(
                    cardChild: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: teamSelect == TeamSelect.team1
                              ? Border.all(color: Colors.pinkAccent, width: 4)
                              : null),
                      height: 100,
                      width: 150,
                      child: Center(child: Image.asset(team1.imageAddress)),
                    ),
                    onTap: () {
                      setState(() {
                        teamSelect = TeamSelect.team1;
                        teamChosen = 'team1';
                      });
                    },
                  ),
                  ReusableCard(
                    cardChild: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: teamSelect == TeamSelect.team2
                              ? Border.all(color: Colors.pinkAccent, width: 4)
                              : null),
                      height: 100,
                      width: 150,
                      child: Center(child: Image.asset(team2.imageAddress)),
                    ),
                    onTap: () {
                      setState(() {
                        teamSelect = TeamSelect.team2;
                        teamChosen = 'team2';
                      });
                    },
                  )
                ],
              ),
              Text(
                'TOSS WINNER WILL CHOOSE',
                style: headingStyleWhite,
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReusableCard(
                    cardChild: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: tossSelect == TossSelect.bat
                              ? Border.all(color: Colors.pinkAccent, width: 4)
                              : null),
                      height: 100,
                      width: 150,
                      child: Center(child: Image.asset('images/bat.png')),
                    ),
                    onTap: () {
                      setState(() {
                        tossSelect = TossSelect.bat;
                        tossChosen = 'bat';
                      });
                    },
                  ),
                  ReusableCard(
                    cardChild: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: tossSelect == TossSelect.bowl
                              ? Border.all(color: Colors.pinkAccent, width: 4)
                              : null),
                      height: 100,
                      width: 150,
                      child: Center(child: Image.asset('images/ball.png')),
                    ),
                    onTap: () {
                      setState(() {
                        tossSelect = TossSelect.bowl;
                        tossChosen = 'bowl';
                      });
                    },
                  ),
                ],
              ),
              ReusableCard(
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "YOUR TEAM'S SCORE",
                      style: headingStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          runs.toString(),
                          style: headingStyle,
                        ),
                        Text(
                          'runs',
                          style:
                              TextStyle(fontSize: 20, color: Colors.deepPurple),
                        )
                      ],
                    ),
                    Slider(
                        value: runs.toDouble(),
                        activeColor: Colors.pink,
                        inactiveColor: Colors.grey,
                        min: 20,
                        max: 270,
                        onChanged: (value) {
                          setState(() {
                            runs = value.round();
                          });
                        })
                  ],
                ),
                onTap: () {},
              ),
              ReusableCard(
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'WICKETS TAKEN BY YOUR TEAM',
                      style: headingStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      wickets.toString(),
                      style: headingStyle,
                    ),
                    Slider(
                        value: wickets.toDouble(),
                        activeColor: Colors.pink,
                        inactiveColor: Colors.grey,
                        min: 0,
                        max: 10,
                        onChanged: (value) {
                          setState(() {
                            wickets = value.round();
                          });
                        })
                  ],
                ),
                onTap: () {},
              ),
              Text(
                'MAN OF THE MATCH',
                style: headingStyleWhite,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReusableCard(
                    cardChild: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 100,
                      width: 150,
                      child: Center(child: Image.asset(team1.imageAddress)),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.deepPurple,
                          builder: (BuildContext context) {
                            return PlayerPicker(team1.players, (player) {
                              setState(() {
                                playerMOM = player;
                              });
                            });
                          });
                    },
                  ),
                  ReusableCard(
                    cardChild: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 100,
                      width: 150,
                      child: Center(child: Image.asset(team2.imageAddress)),
                    ),
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.deepPurple,
                          context: context,
                          builder: (BuildContext context) {
                            return PlayerPicker(team2.players, (player) {
                              setState(() {
                                playerMOM = player;
                              });
                            });
                          });
                    },
                  )
                ],
              ),
              ReusableCard(
                onTap: () {},
                cardChild: Container(
                  height: 50,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      playerMOM,
                      style: headingStyle,
                    ),
                  ),
                ),
              ),
              ReusableCard(
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'TOTAL FIFTIES',
                      style: headingStyle,
                    ),
                    Text(
                      fifties.toString(),
                      style: headingStyle,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              fifties += 1;
                            });
                          },
                          elevation: 6,
                          constraints:
                              BoxConstraints.tightFor(height: 56, width: 56),
                          shape: CircleBorder(),
                          fillColor: Colors.deepPurple,
                          child: Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        RawMaterialButton(
                          onPressed: () {
                            if (fifties > 0) {
                              setState(() {
                                fifties -= 1;
                              });
                            }
                          },
                          elevation: 6,
                          constraints:
                              BoxConstraints.tightFor(height: 56, width: 56),
                          shape: CircleBorder(),
                          fillColor: Colors.deepPurple,
                          child: Icon(
                            FontAwesomeIcons.minus,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
                onTap: () {},
              ),
              PinkButton(
                  title: 'PREDICT',
                  onTap: _canPredict
                      ? () {
                          Scaffold.of(ctx).showSnackBar(SnackBar(
                              content:
                                  Text('Your Prediction has been saved.')));
                          if (pointDoc.length < 1) {
                            FirebaseFirestore.instance
                                .collection('points')
                                .doc(loggedInUser.email)
                                .set({
                              'points': 0.1,
                              'lastMatchPoints': 0,
                              'email': loggedInUser.email,
                              'username': username,
                              'teamPoints': 0,
                              'tossPoints': 0,
                              'runsPoints': 0.toDouble(),
                              'wktPoints': 0.toDouble(),
                              'playerMOMPoints': 0,
                              'teamColour': 8,
                              'fiftiesPoints': 0,
                            });
                          }
                          FirebaseFirestore.instance
                              .collection('predictions')
                              .doc(loggedInUser.email)
                              .set({
                            'matchNumber': matchNumber,
                            'team': teamChosen,
                            'toss': tossChosen,
                            'playerMOM': playerMOM,
                            'score': runs,
                            'wickets': wickets,
                            'fifties': fifties,
                            'email': loggedInUser.email,
                          });
                        }
                      : () {
                          Scaffold.of(ctx).showSnackBar(snackBar);
                        })
            ],
          ),
        ),
      ),
    );
  }
}
