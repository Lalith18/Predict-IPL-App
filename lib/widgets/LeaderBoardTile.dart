import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/Constants.dart';

class LeaderBoardTile extends StatelessWidget {
  LeaderBoardTile(this.name, this.points, this.lastMatchPoints, this.position);
  final int position, lastMatchPoints;
  final double points;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.deepPurple, width: 2)),
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.pinkAccent, width: 5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 70,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.pinkAccent, width: 5),
                  color: Colors.deepPurple),
              child: Center(
                child: Text(
                  (position + 1).toString(),
                  style: headingStyleWhite,
                ),
              ),
            ),
            Text(
              name,
              style: TextStyle(
                  color: Colors.deepPurple,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 5),
                    color: Colors.deepPurple,
                  ),
                  child: Text(
                    points.floor().toString(),
                    style: headingStyleWhite,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.pinkAccent, width: 5),
                    color: Colors.white,
                  ),
                  child: Text(
                    lastMatchPoints.toString(),
                    style: TextStyle(fontSize: 30, color: Colors.green),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
