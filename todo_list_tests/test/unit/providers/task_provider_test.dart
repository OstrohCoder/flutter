import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_tests/models/task.dart';
import 'package:todo_list_tests/providers/task_provider.dart';

void main() {
  group('TaskProvider', () {
    late TaskProvider provider;

    setUp(() {
      provider = TaskProvider();
    });

    test('initial state is empty', () {
      expect(provider.tasks, isEmpty);
      expect(provider.filter, TaskFilter.all);
    });

    test('addTask adds task to list', () {
      // Arrange
      final task = Task(id: '1', title: 'Test Task', createdAt: DateTime.now());

      // Act
      provider.addTask(task);

      // Assert
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '1');
    });

    test('removeTask removes task from list', () {
      // Arrange
      final task = Task(id: '1', title: 'Test Task', createdAt: DateTime.now());
      provider.addTask(task);

      // Act
      provider.removeTask('1');

      // Assert
      expect(provider.tasks, isEmpty);
    });

    test('toggleTask changes isCompleted status', () {
      // Arrange
      final task = Task(id: '1', title: 'Test Task', createdAt: DateTime.now());
      provider.addTask(task);

      // Act
      provider.toggleTask('1');

      // Assert
      expect(provider.tasks.first.isCompleted, true);

      // Act again
      provider.toggleTask('1');

      // Assert
      expect(provider.tasks.first.isCompleted, false);
    });

    test('setFilter filters tasks correctly', () {
      // Arrange
      provider.addTask(
        Task(id: '1', title: 'Active Task', createdAt: DateTime.now()),
      );
      provider.addTask(
        Task(
          id: '2',
          title: 'Completed Task',
          isCompleted: true,
          createdAt: DateTime.now(),
        ),
      );

      // Act & Assert - Active filter
      provider.setFilter(TaskFilter.active);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '1');

      // Act & Assert - Completed filter
      provider.setFilter(TaskFilter.completed);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '2');

      // Act & Assert - All filter
      provider.setFilter(TaskFilter.all);
      expect(provider.tasks.length, 2);
    });

    test('notifyListeners is called on state change', () {
      // Arrange
      var notified = false;
      provider.addListener(() {
        notified = true;
      });

      // Act
      provider.addTask(Task(id: '1', title: 'Test', createdAt: DateTime.now()));

      // Assert
      expect(notified, true);
    });
  });
}
