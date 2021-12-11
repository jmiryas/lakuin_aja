import 'package:lakuin_aja/models/goals_model.dart';

class TargetModel {
  final String id;
  final String uid;
  final List<GoalsModel> goalsList;

  TargetModel({
    required this.id,
    required this.uid,
    required this.goalsList,
  });
}
