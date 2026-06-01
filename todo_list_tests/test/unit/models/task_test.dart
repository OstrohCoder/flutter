import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_tests/models/task.dart';

void main() {
  group('Task Model', () {
    test('creates Task with required fields', () {
      // Arrange & Act
      final task = Task(
        id: '1',
        title: 'Test Task',
        createdAt: DateTime(2026, 2, 13),
      );

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.isCompleted, false); // Default value
    });

    test('fromJson creates Task from Map', () {
      // Arrange
      final json = {
        'id': '1',
        'title': 'Test Task',
        'isCompleted': true,
        'createdAt': '2026-02-13T10:00:00.000',
      };

      // Act
      final task = Task.fromJson(json);

      // Assert
      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.isCompleted, true);
      expect(task.createdAt, DateTime(2026, 2, 13, 10, 0));
    });

    test('toJson converts Task to Map', () {
      // Arrange
      final task = Task(
        id: '1',
        title: 'Test Task',
        isCompleted: true,
        createdAt: DateTime(2026, 2, 13, 10, 0),
      );

      // Act
      final json = task.toJson();

      // Assert
      expect(json['id'], '1');
      expect(json['title'], 'Test Task');
      expect(json['isCompleted'], true);
      expect(json['createdAt'], '2026-02-13T10:00:00.000');
    });

    test('copyWith creates new Task with updated fields', () {
      // Arrange
      final task = Task(id: '1', title: 'Original', createdAt: DateTime.now());

      // Act
      final updated = task.copyWith(title: 'Updated');

      // Assert
      expect(updated.title, 'Updated');
      expect(updated.id, task.id); // ID не змінюється
      expect(updated.isCompleted, task.isCompleted);
    });
  });
}
