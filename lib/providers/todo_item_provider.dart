import 'package:flutter/material.dart';

import '../models/todo_model.dart';

class TodoItemProvider extends ChangeNotifier {
  final List<TodoModel> _todoList = [];

  List<TodoModel> get todoList => _todoList;

  void addTodo(TodoModel todo) {
    _todoList.add(todo);
    notifyListeners();
  }

  void clearTodo() {
    _todoList.clear();
    notifyListeners();
  }
}
