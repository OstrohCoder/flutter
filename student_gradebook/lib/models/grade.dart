import 'grade_type.dart';

class Grade {
  final int id;
  final double score; // 0-100
  final GradeType type;
  final String description;
  final DateTime date;

  Grade({
    required this.id,
    required this.score,
    required this.type,
    required this.description,
    required this.date,
  });

  String get formattedDate => '${date.day}/${date.month}/${date.year}';

  String get scoreText => score.toStringAsFixed(0);

  String get status {
    if (score >= 90) return 'Excellent';
    if (score >= 75) return 'Good';
    if (score >= 60) return 'Satisfactory';
    return 'Poor';
  }
}
