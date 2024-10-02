import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'task_manager.dart';
import 'task.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskManager(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TaskListScreen(),
    );
  }
}

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Smart Task Manager'),
        centerTitle: true,
      ),
      body: Consumer<TaskManager>(
        builder: (context, taskManager, child) {
          return taskManager.tasks.isEmpty
              ? Center(child: Text('No tasks available.'))
              : ListView.builder(
                  itemCount: taskManager.tasks.length,
                  itemBuilder: (context, index) {
                    final task = taskManager.tasks[index];
                    return ListTile(
                      title: Text(task.title),
                      subtitle: Text(task.description),
                      trailing: Chip(
                        label: Text(task.category.toString().split('.').last),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey[800],
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: TaskFormBottomSheet(),
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class TaskFormBottomSheet extends StatefulWidget {
  @override
  _TaskFormBottomSheetState createState() => _TaskFormBottomSheetState();
}

class _TaskFormBottomSheetState extends State<TaskFormBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  DateTime _dueDate = DateTime.now();
  int _priority = 1;
  List<String> _tags = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildTextField(
                label: 'Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onSaved: (value) => _title = value!,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Description',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => _description = value!,
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Due Date (YYYY-MM-DD)',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a due date';
                  }
                  return null;
                },
                onSaved: (value) => _dueDate = DateTime.parse(value!),
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Priority (1-5)',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a priority';
                  }
                  int? priority = int.tryParse(value);
                  if (priority == null || priority < 1 || priority > 5) {
                    return 'Priority must be between 1 and 5';
                  }
                  return null;
                },
                onSaved: (value) => _priority = int.parse(value!),
              ),
              SizedBox(height: 16),
              _buildTextField(
                label: 'Tags (comma-separated)',
                onSaved: (value) =>
                    _tags = value!.split(',').map((tag) => tag.trim()).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  padding:
                      EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _submitForm,
                child:
                    Text('Create Task', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required FormFieldSetter<String> onSaved,
    FormFieldValidator<String>? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blueGrey),
        filled: true,
        fillColor: Colors.grey[200],
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade400, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskManager = Provider.of<TaskManager>(context, listen: false);
      final category = taskManager.categorizeTask(_description);
      final newTask = Task(
        title: _title,
        description: _description,
        dueDate: _dueDate,
        priority: _priority,
        tags: _tags,
        category: category,
      );
      taskManager.addTask(newTask);
      Navigator.pop(context);
    }
  }
}
