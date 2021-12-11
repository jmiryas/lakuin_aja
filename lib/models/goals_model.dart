class GoalsModel {
  final String uid;
  final String id;
  final String label;
  final DateTime dateTime;

  GoalsModel({
    required this.uid,
    required this.id,
    required this.label,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "id": id,
      "label": label,
      "dateTime": dateTime,
    };
  }

  factory GoalsModel.fromJson(Map json) {
    return GoalsModel(
      uid: json["uid"],
      id: json["id"],
      label: json["label"],
      dateTime: json["dateTime"],
    );
  }
}
