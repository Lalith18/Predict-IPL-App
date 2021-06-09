import 'package:flutter/material.dart';
import 'widgets/Constants.dart';
import 'widgets/ReusableCard.dart';
import 'team/TeamClass.dart';
import 'team/TeamData.dart';
import 'widgets/TeamPicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Team team = Teams[8];
  int teamNumber = 8;
  User loggedInUser;
  String username = ' ';
  var pointDoc;
  int teamPoints = 0,
      tossPoints = 0,
      playerMOMPoints = 0,
      lastMatchPoints = 0,
      fiftiesPoints = 0;
  double totalPoints = 0, runsPoints = 0, wicketsPoints = 0;

  void getFavTeam() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedInUser = user;
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.uid)
            .get();
        setState(() {
          username = userDoc.get('username');
          team = Teams[userDoc.get('team')];
        });
        final pointDoc = await FirebaseFirestore.instance
            .collection('points')
            .doc(loggedInUser.email)
            .get();
        if (pointDoc != null) {
          setState(() {
            totalPoints = pointDoc.get('points');
            lastMatchPoints = pointDoc.get('lastMatchPoints').toInt();
            teamPoints = pointDoc.get('teamPoints');
            tossPoints = pointDoc.get('tossPoints');
            playerMOMPoints = pointDoc.get('playerMOMPoints');
            runsPoints = pointDoc.get('runsPoints');
            wicketsPoints = pointDoc.get('wktPoints');
            fiftiesPoints = pointDoc.get('fiftiesPoints');
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getFavTeam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.deepPurple,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: headingStyle,
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.deepPurple),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReusableCard(
                  onTap: () {},
                  cardChild: Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'USERNAME:',
                            style: headingStyle,
                          ),
                          Text(
                            username,
                            style: TextStyle(
                                color: Colors.deepPurple, fontSize: 25),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Text(
                            'FAVOURITE TEAM:',
                            style: headingStyle,
                            textAlign: TextAlign.center,
                          ),
                          ReusableCard(
                            cardChild: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: Colors.pinkAccent, width: 4)),
                              height: 100,
                              width: 100,
                              child: Center(
                                child: Image.asset(team.imageAddress),
                              ),
                            ),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      color: Colors.deepPurple,
                                      child: TeamPicker((tn) {
                                        setState(() {
                                          team = Teams[tn];
                                          teamNumber = tn;
                                        });
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(loggedInUser.uid)
                                            .update({
                                          'team': teamNumber,
                                        });
                                      }),
                                    );
                                  });
                            },
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
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'LAST MATCH POINTS:',
                            style: headingStyle,
                            textAlign: TextAlign.center,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Win prediction",
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                              Text(
                                teamPoints.toString() + ' - 50',
                                style: headingStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "MOM prediction",
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                              Text(
                                playerMOMPoints.toString() + ' - 50',
                                style: headingStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Toss prediction",
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                              Text(
                                tossPoints.toString() + ' - 25',
                                style: headingStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Runs prediction",
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                              Text(
                                runsPoints.toInt().toString() + ' - 25',
                                style: headingStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Wkts prediction",
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                              Text(
                                wicketsPoints.toInt().toString() + ' - 25',
                                style: headingStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Fifties prediction",
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                              Text(
                                fiftiesPoints.toString() + ' - 25',
                                style: headingStyle,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Last match: ",
                                style: TextStyle(
                                    color: Colors.deepPurple, fontSize: 20),
                              ),
                              Text(
                                lastMatchPoints.toString() + ' - 200',
                                style: headingStyle,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
