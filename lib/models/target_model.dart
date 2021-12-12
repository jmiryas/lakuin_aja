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
}
