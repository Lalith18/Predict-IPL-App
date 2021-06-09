import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:predict_ipl/widgets/Constants.dart';
import 'package:predict_ipl/widgets/LeaderBoardTile.dart';

class LeaderBoard extends StatefulWidget {
  @override
  _LeaderBoardState createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LeaderBoard',
          style: headingStyle,
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.deepPurple),
      ),
      backgroundColor: Colors.deepPurple,
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 10),
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 30,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rank',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Name',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    'Points',
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    FontAwesomeIcons.plus,
                    color: Colors.green,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('points')
                    .orderBy('points', descending: true)
                    .snapshots(),
                builder: (context, pointSnapshot) {
                  if (pointSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final pointDocs = pointSnapshot.data.documents;
                  return ListView.builder(
                      itemCount: pointDocs.length,
                      itemBuilder: (ctx, index) => LeaderBoardTile(
                          pointDocs[index].get('username'),
                          pointDocs[index].get('points'),
                          pointDocs[index].get('lastMatchPoints').toInt(),
                          index));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
