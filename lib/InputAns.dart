import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/ReusableCard.dart';
import 'package:predict_ipl/widgets/Constants.dart';
import 'package:predict_ipl/team/TeamData.dart';
import 'package:predict_ipl/team/TeamClass.dart';
import 'package:predict_ipl/widgets/PinkButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'widgets/PlayerPicker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnsScreen extends StatefulWidget {
  @override
  _AnsScreenState createState() => _AnsScreenState();
}

enum TeamSelect {
  team1,
  team2,
}

enum TossSelect {
  bat,
  bowl,
}

class _AnsScreenState extends State<AnsScreen> {
  String predictedTeam, predictedToss, predictedPlayerMOM, userEmail;
  int predictedScore, predictedWickets, predictedMatchNumber, predictedFifties;
  String crctTeam = 'team1', crctToss = 'bat';
  var teamSelect = TeamSelect.team1;
  var tossSelect = TossSelect.bat;
  Team team1 = Teams[8];
  Team team2 = Teams[8];
  int crct1Runs = 150;
  int crct1Wickets = 4;
  int crct2Runs = 150;
  int crct2Wickets = 4;
  int matchNumber = 0;
  String username;
  DocumentSnapshot documents;
  bool _isLoading = false;
  String crctPlayerMOM = 'Select a player';
  int crctFifties = 0;

  getUserPoints() async {
    try {
      final pointsData =
          await FirebaseFirestore.instance.collection('points').get();
      return pointsData;
    } catch (e) {
      print(e);
    }
  }

  int modulus(int num) {
    if (num >= 0) {
      return num;
    }
    return -num;
  }

  getUserPrediction() async {
    try {
      final predictionData =
          await FirebaseFirestore.instance.collection('predictions').get();
      return predictionData;
    } catch (e) {
      print(e);
    }
  }

  void getMatch() async {
    final matchData = await FirebaseFirestore.instance
        .collection('new match')
        .doc('xNShtGFMSjCD0Nbg5avM')
        .get();
    setState(() {
      team1 = Teams[matchData.get('team1')];
      team2 = Teams[matchData.get('team2')];
      matchNumber = matchData.get('matchNumber');
    });
  }

  @override
  void initState() {
    super.initState();
    getMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'UPDATE ANSWERS',
          style: headingStyle,
        ),
        iconTheme: IconThemeData(color: Colors.deepPurple),
      ),
      backgroundColor: Colors.deepPurple,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Builder(
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
                          crctTeam = 'team1';
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
                          crctTeam = 'team2';
                        });
                      },
                    )
                  ],
                ),
                Text(
                  'TOSS WINNER CHOSE',
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
                          crctToss = 'bat';
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
                          crctToss = 'bowl';
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
                        '1st TEAM SCORE',
                        style: headingStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            crct1Runs.toString(),
                            style: headingStyle,
                          ),
                          Text(
                            'runs',
                            style: TextStyle(
                                fontSize: 20, color: Colors.deepPurple),
                          )
                        ],
                      ),
                      Slider(
                          value: crct1Runs.toDouble(),
                          activeColor: Colors.pink,
                          inactiveColor: Colors.grey,
                          min: 20,
                          max: 270,
                          onChanged: (value) {
                            setState(() {
                              crct1Runs = value.round();
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
                        '1st TEAM WICKETS',
                        style: headingStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        crct1Wickets.toString(),
                        style: headingStyle,
                      ),
                      Slider(
                          value: crct1Wickets.toDouble(),
                          activeColor: Colors.pink,
                          inactiveColor: Colors.grey,
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            setState(() {
                              crct1Wickets = value.round();
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
                        '2nd TEAM SCORE',
                        style: headingStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            crct2Runs.toString(),
                            style: headingStyle,
                          ),
                          Text(
                            'runs',
                            style: TextStyle(
                                fontSize: 20, color: Colors.deepPurple),
                          )
                        ],
                      ),
                      Slider(
                          value: crct2Runs.toDouble(),
                          activeColor: Colors.pink,
                          inactiveColor: Colors.grey,
                          min: 20,
                          max: 270,
                          onChanged: (value) {
                            setState(() {
                              crct2Runs = value.round();
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
                        '2nd TEAM WICKETS',
                        style: headingStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        crct2Wickets.toString(),
                        style: headingStyle,
                      ),
                      Slider(
                          value: crct2Wickets.toDouble(),
                          activeColor: Colors.pink,
                          inactiveColor: Colors.grey,
                          min: 0,
                          max: 10,
                          onChanged: (value) {
                            setState(() {
                              crct2Wickets = value.round();
                            });
                          })
                    ],
                  ),
                  onTap: () {},
                ),
                Text(
                  'Man of the Match',
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
                                  crctPlayerMOM = player;
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
                                  crctPlayerMOM = player;
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
                        crctPlayerMOM,
                        style: headingStyle,
                      ),
                    ),
                  ),
                ),
                ReusableCard(
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TOTAL FIFTIES',
                        style: headingStyle,
                      ),
                      Text(
                        crctFifties.toString(),
                        style: headingStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RawMaterialButton(
                            onPressed: () {
                              setState(() {
                                crctFifties += 1;
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
                              setState(() {
                                crctFifties -= 1;
                              });
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
                FutureBuilder(
                    future: getUserPrediction(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return FutureBuilder(
                          future: getUserPoints(),
                          builder: (context, pointsSnapshot) {
                            if (!pointsSnapshot.hasData) {
                              return CircularProgressIndicator();
                            }
                            return PinkButton(
                                title: 'UPDATE ANSWER',
                                onTap: () {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  Scaffold.of(ctx).showSnackBar(SnackBar(
                                      content: Text(
                                          'Correct answers has been saved.')));
                                  FirebaseFirestore.instance
                                      .collection('correct answer')
                                      .doc('IuIigQfMmSvcsmhXtXGC')
                                      .set({
                                    'matchNumber': matchNumber,
                                    'team': crctTeam,
                                    'toss': crctToss,
                                    'team1Score': crct1Runs,
                                    'team1Wickets': crct1Wickets,
                                    'team2Score': crct2Runs,
                                    'team2Wickets': crct2Wickets,
                                    'playerMOM': crctPlayerMOM,
                                    'fifties': crctFifties,
                                  });
                                  final userPredict = snapshot.data.documents;
                                  final pointsData =
                                      pointsSnapshot.data.documents;
                                  for (dynamic document in userPredict) {
                                    predictedTeam = document.get('team');
                                    predictedToss = document.get('toss');
                                    predictedPlayerMOM =
                                        document.get('playerMOM');
                                    predictedScore = document.get('score');
                                    predictedWickets = document.get('wickets');
                                    predictedMatchNumber =
                                        document.get('matchNumber');
                                    predictedFifties = document.get('fifties');
                                    userEmail = document.get('email');
                                    if (predictedMatchNumber == matchNumber) {
                                      double points;
                                      int teamPoints,
                                          tossPoints,
                                          fiftiesPoints,
                                          playerMOMPoints;
                                      double scorePoints,
                                          wktPoints,
                                          lastMatchPoints;
                                      for (dynamic doc in pointsData) {
                                        if (doc.get('email') == userEmail) {
                                          points = doc.get('points');
                                          username = doc.get('username');
                                          if (predictedTeam == 'team1') {
                                            scorePoints = ((270 -
                                                        modulus(crct1Runs -
                                                            predictedScore)) /
                                                    270) *
                                                25;
                                            wktPoints = ((10 -
                                                        modulus(crct1Wickets -
                                                            predictedWickets)) /
                                                    10) *
                                                25;
                                          } else {
                                            scorePoints = ((270 -
                                                        modulus(crct2Runs -
                                                            predictedScore)) /
                                                    270) *
                                                25;
                                            wktPoints = ((10 -
                                                        modulus(crct2Wickets -
                                                            predictedWickets)) /
                                                    10) *
                                                25;
                                          }

                                          if (predictedTeam == crctTeam) {
                                            teamPoints = 50;
                                          } else {
                                            teamPoints = 0;
                                          }
                                          if (predictedToss == crctToss) {
                                            tossPoints = 25;
                                          } else {
                                            tossPoints = 0;
                                          }
                                          if (predictedFifties == crctFifties) {
                                            fiftiesPoints = 25;
                                          } else {
                                            fiftiesPoints = 0;
                                          }
                                          if (predictedPlayerMOM ==
                                              crctPlayerMOM) {
                                            playerMOMPoints = 50;
                                          } else {
                                            playerMOMPoints = 0;
                                          }
                                          lastMatchPoints = teamPoints +
                                              tossPoints +
                                              wktPoints +
                                              scorePoints +
                                              fiftiesPoints +
                                              playerMOMPoints;
                                          points = points + lastMatchPoints;
                                          FirebaseFirestore.instance
                                              .collection('points')
                                              .doc(userEmail)
                                              .set({
                                            'points': points,
                                            'lastMatchPoints':
                                                lastMatchPoints.toInt(),
                                            'email': userEmail,
                                            'username': username,
                                            'teamPoints': teamPoints,
                                            'tossPoints': tossPoints,
                                            'runsPoints': scorePoints,
                                            'wktPoints': wktPoints,
                                            'fiftiesPoints': fiftiesPoints,
                                            'playerMOMPoints': playerMOMPoints,
                                          });
                                        }
                                      }
                                    }
                                  }
                                  setState(() {
                                    _isLoading = false;
                                  });
                                });
                          });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
