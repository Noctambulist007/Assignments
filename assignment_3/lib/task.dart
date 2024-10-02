enum TaskCategory { work, personal, shopping, urgent }

class Task {
  final String title;
  final String description;
  final DateTime dueDate;
  final int priority;
  final List<String> tags;
  final TaskCategory category;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.tags,
    required this.category,
  });
}
