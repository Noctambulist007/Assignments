import 'package:flutter/material.dart';
import 'task.dart';

class TaskManager extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  TaskCategory categorizeTask(String description) {
    if (RegExp(
            r'\b(meeting|presentation|client|project|deadline)\b|\b[\w._%+-]+@[\w.-]+\.[A-Za-z]{2,4}\b',
            caseSensitive: false)
        .hasMatch(description)) {
      return TaskCategory.work;
    } else if (RegExp(r'\b\d+\s*(kg|g|l|pcs)\b', caseSensitive: false)
        .hasMatch(description)) {
      return TaskCategory.shopping;
    } else if (RegExp(r'\b(urgent|ASAP|today|tomorrow)\b|\b\d{4}-\d{2}-\d{2}\b',
            caseSensitive: false)
        .hasMatch(description)) {
      return TaskCategory.urgent;
    } else {
      return TaskCategory.personal;
    }
  }
}
