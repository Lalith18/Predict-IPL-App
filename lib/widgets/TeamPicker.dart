import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/ReusableCard.dart';
import 'package:predict_ipl/team/TeamData.dart';

class TeamPicker extends StatelessWidget {
  final Function selectTeam;
  TeamPicker(this.selectTeam);
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[0].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(0);
            Navigator.pop(context);
          },
        ),
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[1].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(1);
            Navigator.pop(context);
          },
        ),
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[2].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(2);
            Navigator.pop(context);
          },
        ),
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[3].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(3);
            Navigator.pop(context);
          },
        ),
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[4].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(4);
            Navigator.pop(context);
          },
        ),
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[5].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(5);
            Navigator.pop(context);
          },
        ),
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[6].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(6);
            Navigator.pop(context);
          },
        ),
        ReusableCard(
          cardChild: Center(
            child: Image.asset(
              Teams[7].imageAddress,
            ),
          ),
          onTap: () {
            selectTeam(7);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
