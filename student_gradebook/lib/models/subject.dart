import 'grade.dart';

class Subject {
  final int id;
  final String name;
  final String icon; // emoji: 📘, 💻, 📗, etc.
  final List<Grade> grades;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.grades,
  });

  double get average {
    if (grades.isEmpty) return 0.0;
    final sum = grades.fold(0.0, (sum, grade) => sum + grade.score);
    return sum / grades.length;
  }

  String get status {
    final avg = average;
    if (avg >= 90) return 'Excellent';
    if (avg >= 75) return 'Good';
    if (avg >= 60) return 'Satisfactory';
    return 'Poor';
  }

  int get stars {
    final avg = average;
    if (avg >= 90) return 5;
    if (avg >= 80) return 4;
    if (avg >= 70) return 3;
    if (avg >= 60) return 2;
    return 1;
  }

  void addGrade(Grade grade) {
    grades.add(grade);
  }

  void removeGrade(int id) {
    grades.removeWhere((g) => g.id == id);
  }
}
