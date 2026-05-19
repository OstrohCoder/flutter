import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../services/storage_service.dart';
import 'stats_screen.dart';

class TodoScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  const TodoScreen({super.key, required this.onToggleTheme});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final StorageService _storage = StorageService();

  List<TodoItem> _todos = [];
  final TextEditingController _textController = TextEditingController();
  bool _isDarkMode = false;
  bool _isLoading = true;

  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final todos = await _storage.loadTodos();
    final isDarkMode = _storage.loadThemeMode();

    setState(() {
      _todos = todos;
      _isDarkMode = isDarkMode;
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    await _storage.saveTodos(_todos);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('💾 Saved successfully'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _addTodo() {
    if (_textController.text.trim().isEmpty) return;

    final newTodo = TodoItem(
      id: DateTime.now().toString(),
      title: _textController.text.trim(),
      category: _selectedCategory,
      isCompleted: false,
      createdAt: DateTime.now(),
    );

    setState(() {
      _todos.add(newTodo);
    });

    _textController.clear();
    setState(() => _selectedCategory = null);
    _saveData();

    _storage.incrementTotalTasks();
    _storage.updateStreak();
  }

  void _toggleTodo(TodoItem todo) {
    setState(() {
      final index = _todos.indexWhere((t) => t.id == todo.id);
      if (index != -1) {
        _todos[index] = todo.copyWith(isCompleted: !todo.isCompleted);
      }
    });
    _saveData();
  }

  void _deleteTodo(TodoItem todo) {
    setState(() {
      _todos.removeWhere((t) => t.id == todo.id);
    });
    _saveData();
  }

  void _clearCompleted() {
    setState(() {
      _todos.removeWhere((todo) => todo.isCompleted);
    });
    _saveData();
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    widget.onToggleTheme();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Todo List'),
        actions: [
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StatsScreen(todos: _todos)),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _textController,
                              decoration: const InputDecoration(
                                hintText: 'Add new task...',
                                border: OutlineInputBorder(),
                              ),
                              onSubmitted: (_) => _addTodo(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton.filled(
                            icon: const Icon(Icons.add),
                            onPressed: _addTodo,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: ['Work', 'Personal', 'Shopping'].map((cat) {
                          return FilterChip(
                            label: Text(cat),
                            selected: _selectedCategory == cat,
                            onSelected: (selected) => setState(
                              () => _selectedCategory = selected ? cat : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),
                const Divider(height: 10),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '📋 Tasks (${_todos.length})',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: _todos.isEmpty ? _buildEmptyState() : _buildTodoList(),
                ),

                _buildFooter(),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No tasks yet!',
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Add your first task above',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoList() {
    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: Checkbox(
              value: todo.isCompleted,
              onChanged: (_) => _toggleTodo(todo),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: todo.category != null ? Text(todo.category!) : null,
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTodo(todo),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter() {
    final completedCount = _todos.where((t) => t.isCompleted).length;
    final lastSaveTime = _storage.getLastSaveTime();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('✅ Completed: $completedCount/${_todos.length}'),
              if (lastSaveTime != null)
                Text(
                  '💾 Last saved: $lastSaveTime',
                  style: TextStyle(fontSize: 12),
                ),
            ],
          ),
          if (completedCount > 0) ...[
            SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _clearCompleted,
                child: Text('Clear All Completed'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
