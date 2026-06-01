import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_tests/widgets/add_task_form.dart';

void main() {
  group('AddTaskForm Widget', () {
    testWidgets('displays TextField and button', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddTaskForm(onSubmit: (_) {})),
        ),
      );

      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.text('Add Task'), findsOneWidget);
    });

    testWidgets('shows error for empty title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddTaskForm(onSubmit: (_) {})),
        ),
      );

      // Tap submit without entering text
      await tester.tap(find.text('Add Task'));
      await tester.pump(); // Trigger validation

      // Validation error should appear
      expect(find.text('Title cannot be empty'), findsOneWidget);
    });

    testWidgets('accepts text input', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddTaskForm(onSubmit: (_) {})),
        ),
      );

      // Enter text
      await tester.enterText(find.byType(TextFormField), 'New Task');
      await tester.pump();

      // Text should be in the field
      expect(find.text('New Task'), findsOneWidget);
    });

    testWidgets('calls onSubmit with valid title', (WidgetTester tester) async {
      String? submittedTitle;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AddTaskForm(
              onSubmit: (title) {
                submittedTitle = title;
              },
            ),
          ),
        ),
      );

      // Enter valid text
      await tester.enterText(find.byType(TextFormField), 'Valid Task');
      await tester.pump();

      // Tap submit
      await tester.tap(find.text('Add Task'));
      await tester.pump();

      // onSubmit should be called
      expect(submittedTitle, 'Valid Task');
    });

    testWidgets('clears field after submit', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: AddTaskForm(onSubmit: (_) {})),
        ),
      );

      // Enter and submit
      await tester.enterText(find.byType(TextFormField), 'Task');
      await tester.tap(find.text('Add Task'));
      await tester.pump();

      // Field should be cleared
      final textField = tester.widget<TextFormField>(
        find.byType(TextFormField),
      );
      expect(textField.controller?.text, isEmpty);
    });
  });
}
