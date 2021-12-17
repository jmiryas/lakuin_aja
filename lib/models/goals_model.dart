import 'package:cloud_firestore/cloud_firestore.dart';

class GoalsModel {
  final String uid;
  final String id;
  final String label;
  final DateTime dateTime;
  final DateTime startTime;
  final DateTime endTime;
  final bool complete;

  GoalsModel({
    required this.uid,
    required this.id,
    required this.label,
    required this.dateTime,
    required this.startTime,
    required this.endTime,
    this.complete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "id": id,
      "label": label,
      "dateTime": dateTime,
      "startTime": startTime,
      "endTime": endTime,
      "complete": complete,
    };
  }

  factory GoalsModel.fromJson(Map json) {
    return GoalsModel(
      uid: json["uid"],
      id: json["id"],
      label: json["label"],
      dateTime: json["dateTime"],
      startTime: json["startTime"],
      endTime: json["endTime"],
      complete: json["complete"],
    );
  }

  static getTimeOnly(Timestamp timestamp) {
    return timestamp.toDate().toString().substring(10, 16);
  }
}
