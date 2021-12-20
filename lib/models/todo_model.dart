class TodoModel {
  final String id;
  final String uid;
  final String label;
  final bool complete;
  final DateTime dateTime;

  TodoModel({
    required this.id,
    required this.uid,
    required this.label,
    this.complete = false,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "uid": uid,
      "label": label,
      "complete": complete,
      "dateTime": dateTime,
    };
  }

  factory TodoModel.fromJson(Map json) {
    return TodoModel(
      id: json["id"],
      uid: json["uid"],
      label: json["label"],
      complete: json["complete"],
      dateTime: json["dateTime"],
    );
  }
}
