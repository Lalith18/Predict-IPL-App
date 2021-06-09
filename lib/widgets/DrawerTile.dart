import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  DrawerTile({this.title, this.onTap, this.icon});
  final String title;
  final IconData icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.deepPurple,
        ),
      ),
      leading: Icon(
        icon,
        color: Colors.deepPurple,
      ),
      onTap: onTap,
    );
  }
}
