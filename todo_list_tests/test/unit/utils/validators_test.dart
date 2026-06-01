import 'package:flutter_test/flutter_test.dart';
import 'package:todo_list_tests/utils/validators.dart';

void main() {
  group('Validators', () {
    group('validateTitle', () {
      test('returns null for valid title', () {
        expect(Validators.validateTitle('Valid Title'), isNull);
      });

      test('returns error for empty title', () {
        expect(Validators.validateTitle(''), 'Title cannot be empty');
      });

      test('returns error for null title', () {
        expect(Validators.validateTitle(null), 'Title cannot be empty');
      });

      test('returns error for short title', () {
        expect(
          Validators.validateTitle('Ab'),
          'Title must be at least 3 characters',
        );
      });
    });

    group('validateEmail', () {
      test('returns null for valid email', () {
        expect(Validators.validateEmail('test@example.com'), isNull);
      });

      test('returns error for invalid email', () {
        expect(
          Validators.validateEmail('invalid-email'),
          'Invalid email format',
        );
      });

      test('returns error for empty email', () {
        expect(Validators.validateEmail(''), 'Email cannot be empty');
      });
    });

    group('isTaskOverdue', () {
      test('returns true for past date', () {
        final pastDate = DateTime.now().subtract(Duration(days: 1));
        expect(Validators.isTaskOverdue(pastDate), true);
      });

      test('returns false for future date', () {
        final futureDate = DateTime.now().add(Duration(days: 1));
        expect(Validators.isTaskOverdue(futureDate), false);
      });
    });
  });
}
