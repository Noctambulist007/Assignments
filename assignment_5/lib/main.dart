import 'package:flutter/material.dart';

void main() {
  runApp(const ContextualToDoApp());
}

class ContextualToDoApp extends StatelessWidget {
  const ContextualToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Color To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ToDoListScreen(),
    );
  }
}

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  final List<Map<String, dynamic>> tasks = [
    {'title': 'Buy groceries', 'completed': false},
    {'title': 'Walk the dog', 'completed': false},
    {'title': 'Study Flutter', 'completed': true},
  ];

  final Set<int> selectedTasks = {};

  bool get isSelectionMode => selectedTasks.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: isSelectionMode ? Colors.indigo : Colors.blue,
        title: Text(isSelectionMode
            ? '${selectedTasks.length} Selected'
            : 'Color To-Do App'),
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    setState(() {
                      for (var index in selectedTasks) {
                        tasks[index]['completed'] = true;
                      }
                      selectedTasks.clear();
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      tasks.removeWhere((task) =>
                          selectedTasks.contains(tasks.indexOf(task)));
                      selectedTasks.clear();
                    });
                  },
                ),
              ]
            : null,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          final isSelected = selectedTasks.contains(index);

          return GestureDetector(
            onLongPress: () {
              setState(() {
                selectedTasks.add(index);
              });
            },
            onTap: () {
              setState(() {
                if (isSelected) {
                  selectedTasks.remove(index);
                } else {
                  selectedTasks.add(index);
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: task['completed']
                      ? [Colors.greenAccent, Colors.green]
                      : isSelected
                          ? [Colors.indigo, Colors.blue]
                          : [Colors.orangeAccent, Colors.deepOrange],
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    task['completed']
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      task['title'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await _showAddTaskDialog(context);
          if (newTask != null && newTask.isNotEmpty) {
            setState(() {
              tasks.add({'title': newTask, 'completed': false});
            });
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<String?> _showAddTaskDialog(BuildContext context) async {
    String? newTask;

    return showDialog<String>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add_task,
                  size: 50,
                  color: Colors.white,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Add New Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter task title',
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => newTask = value,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context, null),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context, newTask),
                      child: const Text(
                        'Add Task',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
