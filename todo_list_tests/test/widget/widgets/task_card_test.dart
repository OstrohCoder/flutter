import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_tests/models/task.dart';
import 'package:todo_list_tests/widgets/task_card.dart';

void main() {
  group('TaskCard Widget', () {
    late Task testTask;

    setUp(() {
      testTask = Task(id: '1', title: 'Test Task', createdAt: DateTime.now());
    });

    testWidgets('displays task title', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );

      // Act & Assert
      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('displays checkbox', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );

      // Act & Assert
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('checkbox reflects isCompleted state', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask.copyWith(isCompleted: true),
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Act
      final checkbox = tester.widget<Checkbox>(find.byType(Checkbox));

      // Assert
      expect(checkbox.value, true);
    });

    testWidgets('displays delete button', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(task: testTask, onToggle: () {}, onDelete: () {}),
          ),
        ),
      );

      // Act & Assert
      expect(find.byIcon(Icons.delete), findsOneWidget);
    });

    testWidgets('checkbox tap calls onToggle', (WidgetTester tester) async {
      // Arrange
      var toggleCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onToggle: () {
                toggleCalled = true;
              },
              onDelete: () {},
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(Checkbox));
      await tester.pump(); // Rebuild widget

      // Assert
      expect(toggleCalled, true);
    });

    testWidgets('delete button tap calls onDelete', (
      WidgetTester tester,
    ) async {
      // Arrange
      var deleteCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: testTask,
              onToggle: () {},
              onDelete: () {
                deleteCalled = true;
              },
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pump();

      // Assert
      expect(deleteCalled, true);
    });

    testWidgets('completed task shows strikethrough', (
      WidgetTester tester,
    ) async {
      // Arrange
      final completedTask = testTask.copyWith(isCompleted: true);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TaskCard(
              task: completedTask,
              onToggle: () {},
              onDelete: () {},
            ),
          ),
        ),
      );

      // Act
      final text = tester.widget<Text>(find.text('Test Task'));

      // Assert
      expect(text.style?.decoration, TextDecoration.lineThrough);
    });
  });
}
