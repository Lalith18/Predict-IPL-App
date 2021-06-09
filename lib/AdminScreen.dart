import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/ReusableCard.dart';
import 'package:predict_ipl/widgets/Constants.dart';
import 'package:predict_ipl/widgets/TeamPicker.dart';
import 'package:predict_ipl/widgets/PinkButton.dart';
import 'package:predict_ipl/team/TeamClass.dart';
import 'package:predict_ipl/team/TeamData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:predict_ipl/widgets/MainDrawer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int team1Number = 0, team2Number = 1;
  int matchNumber = 0;
  bool _enablePredict = false;
  Team team1 = Teams[8];
  Team team2 = Teams[8];

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
      _enablePredict = predictData.get('canPredict');
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
      drawer: MainDrawer(),
      appBar: AppBar(
        title: Text(
          'Admin Screen',
          style: headingStyle,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepPurple),
      ),
      backgroundColor: Colors.deepPurple,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            PinkButton(
                title: 'Update Answers',
                onTap: () {
                  Navigator.pushNamed(context, 'AnsScreen');
                }),
            Container(
              margin: EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Enable Prediction: ',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  Checkbox(
                    activeColor: Colors.deepPurple,
                    value: _enablePredict,
                    onChanged: (value) {
                      setState(() {
                        _enablePredict = value;
                        FirebaseFirestore.instance
                            .collection('canPredict')
                            .doc('e2aOvl6xoTziNPMoXTZo')
                            .update({'canPredict': value});
                      });
                    },
                  )
                ],
              ),
            ),
            Text(
              'UPCOMING MATCH',
              style: headingStyleWhite,
            ),
            ReusableCard(
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'MATCH',
                    style: headingStyle,
                  ),
                  Text(
                    matchNumber.toString(),
                    style: headingStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RawMaterialButton(
                        onPressed: () {
                          setState(() {
                            matchNumber += 1;
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
                            matchNumber -= 1;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            matchNumber -= 1;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableCard(
                  cardChild: Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Image.asset(team1.imageAddress),
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            color: Colors.deepPurple,
                            child: TeamPicker((teamNumber) {
                              setState(() {
                                team1 = Teams[teamNumber];
                                team1Number = teamNumber;
                              });
                            }),
                          );
                        });
                  },
                ),
                Text(
                  'VS',
                  style: headingStyleWhite,
                ),
                ReusableCard(
                  cardChild: Container(
                    height: 100,
                    width: 100,
                    child: Center(
                      child: Image.asset(team2.imageAddress),
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            color: Colors.deepPurple,
                            child: TeamPicker((teamNumber2) {
                              setState(() {
                                team2 = Teams[teamNumber2];
                                team2Number = teamNumber2;
                              });
                            }),
                          );
                        });
                  },
                ),
              ],
            ),
            PinkButton(
                title: 'Set Game',
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('new match')
                      .doc('xNShtGFMSjCD0Nbg5avM')
                      .update({
                    'team1': team1Number,
                    'team2': team2Number,
                    'matchNumber': matchNumber,
                  });
                }),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
