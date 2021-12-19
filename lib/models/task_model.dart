class TaskModel {
  final String id;
  final String uid;
  final String label;
  final int color;
  final List<dynamic> todos;

  TaskModel({
    required this.id,
    required this.uid,
    required this.label,
    required this.color,
    this.todos = const [{}],
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "uid": uid,
      "label": label,
      "color": color,
      "todos": todos,
    };
  }

  factory TaskModel.fromJson(Map json) {
    return TaskModel(
      id: json["id"],
      uid: json["uid"],
      label: json["label"],
      color: json["color"],
      todos: json["todos"],
    );
  }
}
