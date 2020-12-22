import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class TaskCard {
  final int id;
  final String row;
  final int seqNum;
  final String text;
  TaskCard({
    @required this.id,
    @required this.row,
    @required this.seqNum,
    @required this.text,
  });
}

class CardsResponse {
  final String error;
  final List<TaskCard> cards;
  CardsResponse({@required this.cards, @required this.error});
}