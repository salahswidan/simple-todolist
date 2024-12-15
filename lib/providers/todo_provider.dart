import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/todo_model.dart';

class TodoProvider with ChangeNotifier {
  Box<Todo> get todoBox => Hive.box<Todo>('todos');

  void addTodo(Todo todo) {
    todoBox.add(todo);
    notifyListeners();
  }

  void updateTodo(int index, Todo updatedTodo) {
    todoBox.putAt(index, updatedTodo);
    notifyListeners();
  }

  void deleteTodo(int index) {
    todoBox.deleteAt(index);
    notifyListeners();
  }
}
