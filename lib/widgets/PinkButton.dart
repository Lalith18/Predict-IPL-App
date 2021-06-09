import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:predict_ipl/widgets/Constants.dart';

class PinkButton extends StatelessWidget {
  PinkButton({@required this.title, @required this.onTap});
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.pinkAccent,
        ),
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.symmetric(vertical: 5),
        width: 200,
        child: Center(
          child: Text(
            title,
            style: headingStyleWhite,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
