enum TaskCategory { work, personal, shopping }

enum Priority { low, medium, high }

class Task {
  final int id;
  final String title;
  bool isDone;
  final TaskCategory category;
  final Priority priority;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
    this.category = TaskCategory.personal,
    this.priority = Priority.medium,
  });

  void toggle() => isDone = !isDone;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'category': category.name,
      'priority': priority.name,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      isDone: json['isDone'],
      category: TaskCategory.values.firstWhere(
        (e) => e.name == json['category'],
      ),
      priority: Priority.values.firstWhere((e) => e.name == json['priority']),
    );
  }
}
