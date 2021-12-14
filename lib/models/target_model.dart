import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/goals_model.dart';

class TargetModel {
  final String id;
  final String uid;
  final DateTime dateTime;
  final List<GoalsModel> goalsList;

  TargetModel({
    required this.id,
    required this.uid,
    required this.dateTime,
    required this.goalsList,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "uid": uid,
      "dateTime": dateTime,
      "goalsList": goalsList,
    };
  }

  factory TargetModel.fromJson(Map json) {
    return TargetModel(
      id: json["id"],
      uid: json["uid"],
      dateTime: json["dateTime"],
      goalsList: json["goalsList"],
    );
  }

  static Color getTargetColor(DateTime dateTime) {
    switch (DateFormat("EEEE").format(dateTime)) {
      case "Monday":
        return const Color(0xFF16a085);
      case "Tuesday":
        return const Color(0xFFf39c12);
      case "Wednesday":
        return const Color(0xFF2980b9);
      case "Thursday":
        return const Color(0xFFc0392b);
      case "Friday":
        return const Color(0xFF2c3e50);
      case "Saturday":
        return const Color(0xFFfdcb6e);
      case "Sunday":
        return const Color(0xFFe17055);
      default:
        return Colors.black;
    }
  }
}
