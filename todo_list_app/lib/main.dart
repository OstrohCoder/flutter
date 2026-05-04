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

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();

    _tasks = [
      Task(id: 1, title: 'Buy groceries', isDone: true),
      Task(id: 2, title: 'Finish homework'),
      Task(id: 3, title: 'Call mom', isDone: true),
      Task(id: 4, title: 'Read a book'),
      Task(id: 5, title: 'Exercise', isDone: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          _buildStatistics(),
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
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];

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
                      leading: Checkbox(
                        value: task.isDone,
                        onChanged: (value) => _toggleTask(task.id),
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
  }

  void _deleteTask(int id) {
    setState(() {
      _tasks.removeWhere((task) => task.id == id);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Task deleted')));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
