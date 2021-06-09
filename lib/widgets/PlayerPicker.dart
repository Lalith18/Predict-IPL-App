import 'package:flutter/material.dart';

class PlayerPicker extends StatelessWidget {
  PlayerPicker(this.team, this.selectPlayer);
  final List<String> team;
  final Function selectPlayer;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: team.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Container(
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              margin: EdgeInsets.all(2),
              child: Center(
                child: Text(
                  team[index],
                  style: TextStyle(fontSize: 30, color: Colors.deepPurple),
                ),
              ),
            ),
            onTap: () {
              selectPlayer(team[index]);
              Navigator.pop(context);
            },
          );
        });
  }
}
