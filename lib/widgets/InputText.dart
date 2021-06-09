import 'package:flutter/material.dart';

class InputText extends StatelessWidget {
  final caps;
  final bool hidden;
  final IconData icon;
  final String hintText;
  final Function onChanged;
  final Function validate;
  InputText(
      {this.hidden,
      this.icon,
      this.hintText,
      this.onChanged,
      this.validate,
      this.caps});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey(hintText),
      autocorrect: false,
      textCapitalization: caps,
      onSaved: onChanged,
      validator: validate,
      keyboardType: TextInputType.emailAddress,
      obscureText: hidden,
      decoration: InputDecoration(
        hintText: hintText,
        icon: Icon(
          icon,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
