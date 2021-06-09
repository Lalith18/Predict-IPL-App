import 'package:flutter/material.dart';

class Team {
  const Team(
      {@required this.name,
      @required this.imageAddress,
      @required this.players});
  final name, imageAddress;
  final List<String> players;
}
