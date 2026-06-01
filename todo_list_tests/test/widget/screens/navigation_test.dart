import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Navigation', () {
    testWidgets('navigates to details screen', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
          routes: {'/details': (context) => const DetailsScreen()},
        ),
      );

      // Verify we're on HomeScreen
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Details Screen'), findsNothing);

      // Act - tap button to navigate
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle(); // Wait for navigation animation

      // Assert - now on DetailsScreen
      expect(find.text('Home Screen'), findsNothing);
      expect(find.text('Details Screen'), findsOneWidget);
    });

    testWidgets('back button returns to home', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HomeScreen(),
          routes: {'/details': (context) => const DetailsScreen()},
        ),
      );

      // Navigate to details
      await tester.tap(find.text('Go to Details'));
      await tester.pumpAndSettle();

      // Tap back button
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Should be back on HomeScreen
      expect(find.text('Home Screen'), findsOneWidget);
      expect(find.text('Details Screen'), findsNothing);
    });
  });
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/details'),
          child: const Text('Go to Details'),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details Screen')),
      body: const Center(child: Text('Details Content')),
    );
  }
}
