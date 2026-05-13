import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/grade_type.dart';
import '../widgets/subject_card.dart';
import '../widgets/empty_state.dart';
import 'subject_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Subject> _subjects = [];

  @override
  void initState() {
    super.initState();

    _subjects = [
      Subject(
        id: 1,
        name: 'Mathematics',
        icon: '📘',
        grades: [
          Grade(
            id: 1,
            score: 95,
            type: GradeType.exam,
            description: 'Midterm',
            date: DateTime.now(),
          ),
          Grade(
            id: 2,
            score: 90,
            type: GradeType.quiz,
            description: 'Quiz 5',
            date: DateTime.now(),
          ),
          Grade(
            id: 3,
            score: 88,
            type: GradeType.homework,
            description: 'Homework 3',
            date: DateTime.now(),
          ),
        ],
      ),
      Subject(
        id: 2,
        name: 'Programming',
        icon: '💻',
        grades: [
          Grade(
            id: 4,
            score: 92,
            type: GradeType.exam,
            description: 'Final Exam',
            date: DateTime.now(),
          ),
          Grade(
            id: 5,
            score: 85,
            type: GradeType.quiz,
            description: 'Quiz 2',
            date: DateTime.now(),
          ),
          Grade(
            id: 6,
            score: 80,
            type: GradeType.homework,
            description: 'Project',
            date: DateTime.now(),
          ),
        ],
      ),
      Subject(
        id: 3,
        name: 'Physics',
        icon: '📗',
        grades: [
          Grade(
            id: 7,
            score: 89,
            type: GradeType.exam,
            description: 'Midterm',
            date: DateTime.now(),
          ),
          Grade(
            id: 8,
            score: 84,
            type: GradeType.quiz,
            description: 'Quiz 1',
            date: DateTime.now(),
          ),
          Grade(
            id: 9,
            score: 78,
            type: GradeType.homework,
            description: 'Lab Report',
            date: DateTime.now(),
          ),
        ],
      ),
    ];
  }

  double get _overallAverage {
    if (_subjects.isEmpty) return 0.0;
    final sum = _subjects.fold(0.0, (sum, s) => sum + s.average);
    return sum / _subjects.length;
  }

  Map<String, int> get _statistics {
    final stats = {'Excellent': 0, 'Good': 0, 'Satisfactory': 0, 'Poor': 0};
    for (final subject in _subjects) {
      for (final grade in subject.grades) {
        stats[grade.status] = (stats[grade.status] ?? 0) + 1;
      }
    }
    return stats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Grades'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.blue[50],
            child: Column(
              children: [
                Text(
                  'Overall Average',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  _overallAverage.toStringAsFixed(1),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    return Icon(
                      i < _overallAverage / 2 ? Icons.star : Icons.star_border,
                      size: 24,
                      color: Colors.amber,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  _overallAverage >= 90
                      ? 'Excellent'
                      : _overallAverage >= 75
                      ? 'Good'
                      : _overallAverage >= 60
                      ? 'Satisfactory'
                      : 'Poor',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _overallAverage >= 90
                        ? Colors.green
                        : _overallAverage >= 75
                        ? Colors.blue
                        : _overallAverage >= 60
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Excellent',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${_statistics['Excellent']}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Good',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${_statistics['Good']}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.sentiment_satisfied, color: Colors.blue),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Satisfactory',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${_statistics['Satisfactory']}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.sentiment_neutral, color: Colors.orange),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Poor',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${_statistics['Poor']}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Subjects',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),

          Expanded(
            child: _subjects.isEmpty
                ? const EmptyState()
                : ListView.builder(
                    itemCount: _subjects.length,
                    itemBuilder: (context, index) {
                      return SubjectCard(
                        subject: _subjects[index],
                        onTap: () =>
                            _navigateToSubjectDetails(_subjects[index]),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubjectDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSubjectDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Оберіть предмет'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _subjects.length,
              itemBuilder: (context, index) {
                final subject = _subjects[index];
                return ListTile(
                  leading: Text(
                    subject.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(subject.name),
                  onTap: () {
                    Navigator.pop(context);

                    _navigateToSubjectDetails(subject);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _navigateToSubjectDetails(Subject subject) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => SubjectDetailsScreen(subject: subject),
          ),
        )
        .then((_) {
          setState(() {});
        });
  }
}
