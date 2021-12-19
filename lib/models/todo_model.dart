class TodoModel {
  final String id;
  final String uid;
  final String label;
  final bool complete;

  TodoModel({
    required this.id,
    required this.uid,
    required this.label,
    required this.complete,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "uid": uid,
      "label": label,
      "complete": complete,
    };
  }

  factory TodoModel.fromJson(Map json) {
    return TodoModel(
      id: json["id"],
      uid: json["uid"],
      label: json["label"],
      complete: json["complete"],
    );
  }
}
