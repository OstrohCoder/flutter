import 'package:flutter/material.dart';
import '../models/todo_item.dart';
import '../services/storage_service.dart';

class StatsScreen extends StatelessWidget {
  final List<TodoItem> todos;
  const StatsScreen({super.key, required this.todos});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final totalCreated = storage.getTotalTasksCreated();
    final streak = storage.getStreak();

    final today = DateTime.now();
    final completedToday = todos
        .where(
          (t) =>
              t.isCompleted &&
              t.createdAt.day == today.day &&
              t.createdAt.month == today.month &&
              t.createdAt.year == today.year,
        )
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatCard('📋 Total tasks created', '$totalCreated'),
            const SizedBox(height: 16),
            _buildStatCard('✅ Completed today', '$completedToday'),
            const SizedBox(height: 16),
            _buildStatCard('🔥 Current streak', '$streak days'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Card(
      child: ListTile(
        title: Text(label),
        trailing: Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
