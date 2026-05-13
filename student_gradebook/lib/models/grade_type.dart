import 'package:flutter/material.dart';

enum GradeType { exam, quiz, homework, project }

extension GradeTypeExtension on GradeType {
  String get name {
    switch (this) {
      case GradeType.exam:
        return 'Exam';
      case GradeType.quiz:
        return 'Quiz';
      case GradeType.homework:
        return 'Homework';
      case GradeType.project:
        return 'Project';
    }
  }

  IconData get icon {
    switch (this) {
      case GradeType.exam:
        return Icons.description;
      case GradeType.quiz:
        return Icons.quiz;
      case GradeType.homework:
        return Icons.book;
      case GradeType.project:
        return Icons.folder;
    }
  }
}
