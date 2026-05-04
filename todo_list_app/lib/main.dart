import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'models/task.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> _tasks = [];
  late TextEditingController _controller;
  TaskCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();

    _loadTasks().then((_) {
      if (_tasks.isEmpty) {
        setState(() {
          _tasks = [
            Task(
              id: 1,
              title: 'Buy groceries',
              isDone: true,
              category: TaskCategory.shopping,
              priority: Priority.medium,
            ),
            Task(
              id: 2,
              title: 'Finish homework',
              category: TaskCategory.work,
              priority: Priority.low,
            ),
            Task(
              id: 3,
              title: 'Call mom',
              isDone: true,
              category: TaskCategory.personal,
              priority: Priority.high,
            ),
            Task(id: 4, title: 'Read a book'),
            Task(
              id: 5,
              title: 'Exercise',
              isDone: false,
              category: TaskCategory.work,
              priority: Priority.high,
            ),
          ];
        });
      }
    });

    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = _selectedCategory == null
        ? _tasks
        : _tasks.where((t) => t.category == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _buildStatistics(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildChip(null, 'All'),
                  _buildChip(TaskCategory.work, 'Work'),
                  _buildChip(TaskCategory.personal, 'Personal'),
                  _buildChip(TaskCategory.shopping, 'Shopping'),
                ],
              ),
            ),
          ),
          if (_tasks.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No tasks yet!'),
                  Text('Tap + to add', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredTasks.length,
              itemBuilder: (context, index) {
                final task = filteredTasks[index];

                return Dismissible(
                  key: Key(task.id.toString()),
                  onDismissed: (direction) => _deleteTask(task.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),

                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(width: 4),
                          _getPriorityIcon(task.priority),
                          SizedBox(width: 4),

                          Checkbox(
                            value: task.isDone,
                            onChanged: (value) => _toggleTask(task.id),
                          ),
                        ],
                      ),

                      title: Text(
                        task.title,
                        style: TextStyle(
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),

                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTask(task.id),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatistics() {
    final completedCount = _tasks.where((task) => task.isDone).length;
    final totalCount = _tasks.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.blue[50]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$completedCount of $totalCount completed'),
          Icon(Icons.check_circle, color: Colors.green),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Task'),

          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Task title'),
            autofocus: true,
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _controller.clear();
              },
              child: Text('Cancel'),
            ),

            ElevatedButton(onPressed: _addTask, child: Text('Add')),
          ],
        );
      },
    );
  }

  void _addTask() {
    final title = _controller.text.trim();

    if (title.isNotEmpty) {
      setState(() {
        final newTask = Task(
          id: DateTime.now().millisecondsSinceEpoch,
          title: title,
        );

        _tasks.add(newTask);
      });

      _saveTasks();

      _controller.clear();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a task title')));
    }
  }

  void _toggleTask(int id) {
    setState(() {
      final task = _tasks.firstWhere((t) => t.id == id);
      task.toggle();
    });
    _saveTasks();
  }

  void _deleteTask(int id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });

    _saveTasks();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Task deleted')));
  }

  Widget _buildChip(TaskCategory? category, String label) {
    final isSelected = _selectedCategory == category;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          setState(() {
            _selectedCategory = category;
          });
        },
      ),
    );
  }

  Icon _getPriorityIcon(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Icon(Icons.priority_high, color: Colors.red);
      case Priority.medium:
        return Icon(Icons.trending_up, color: Colors.orange);
      case Priority.low:
        return Icon(Icons.low_priority, color: Colors.green);
    }
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    final taskList = _tasks.map((t) => t.toJson()).toList();
    final jsonString = jsonEncode(taskList);

    await prefs.setString('tasks', jsonString);
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('tasks');

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);

      _tasks = decoded.map((e) => Task.fromJson(e)).toList();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
