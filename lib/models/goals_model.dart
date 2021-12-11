class GoalsModel {
  final String uid;
  final String id;
  final String label;
  final DateTime dateTime;
  final bool complete;

  GoalsModel({
    required this.uid,
    required this.id,
    required this.label,
    required this.dateTime,
    this.complete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "id": id,
      "label": label,
      "dateTime": dateTime,
      "complete": complete,
    };
  }

  factory GoalsModel.fromJson(Map json) {
    return GoalsModel(
      uid: json["uid"],
      id: json["id"],
      label: json["label"],
      dateTime: json["dateTime"],
      complete: json["complete"],
    );
  }
}
