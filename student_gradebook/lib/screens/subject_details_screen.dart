import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../models/grade.dart';
import '../models/grade_type.dart';

class SubjectDetailsScreen extends StatefulWidget {
  final Subject subject;

  const SubjectDetailsScreen({super.key, required this.subject});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  final _scoreController = TextEditingController();
  final _descriptionController = TextEditingController();
  GradeType _selectedType = GradeType.exam;

  void _showAddGradeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Grade to ${widget.subject.name}'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _scoreController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Grade (0-100)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButton<GradeType>(
                    value: _selectedType,
                    items: GradeType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.name.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setDialogState(() => _selectedType = value!),
                  ),

                  const SizedBox(height: 16),

                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(onPressed: _addGrade, child: const Text('Add')),
              ],
            );
          },
        );
      },
    );
  }

  void _addGrade() {
    final scoreText = _scoreController.text.trim();
    final description = _descriptionController.text.trim();

    if (scoreText.isEmpty || description.isEmpty) return;

    final score = double.tryParse(scoreText);
    if (score == null || score < 0 || score > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Grade must be between 0 and 100'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      var newGrade = Grade(
        id: DateTime.now().millisecondsSinceEpoch,
        score: score,
        type: _selectedType,
        description: description,
        date: DateTime.now(),
      );

      widget.subject.addGrade(newGrade);

      _scoreController.clear();
      _descriptionController.clear();
    });

    Navigator.pop(context);
  }

  void _deleteGrade(int id) {
    setState(() {
      widget.subject.removeGrade(id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Grade deleted'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject.name)),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            color: Colors.blue[50],
            child: Column(
              children: [
                Text(widget.subject.icon, style: const TextStyle(fontSize: 48)),

                const SizedBox(height: 16),

                Text(
                  'Average: ${widget.subject.average.toStringAsFixed(1)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(5, (i) {
                    return Icon(
                      i < widget.subject.average / 20
                          ? Icons.star
                          : Icons.star_border,
                      size: 24,
                      color: Colors.amber,
                    );
                  }),
                ),

                const SizedBox(height: 16),

                Text(
                  widget.subject.status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: widget.subject.status == 'Excellent'
                        ? Colors.green
                        : widget.subject.status == 'Good'
                        ? Colors.orange
                        : Colors.red,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '${widget.subject.grades.length} grades',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'All Grades',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: widget.subject.grades.length,
              itemBuilder: (context, index) {
                final grade = widget.subject.grades[index];
                return Dismissible(
                  key: Key(grade.id.toString()),
                  onDismissed: (_) => _deleteGrade(grade.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 16),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: Icon(grade.type.icon),
                      title: Text(grade.description),
                      subtitle: Text(grade.formattedDate),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            grade.scoreText,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            grade.status,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: grade.status == 'Excellent'
                                      ? Colors.green
                                      : grade.status == 'Good'
                                      ? Colors.orange
                                      : Colors.red,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGradeDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scoreController.dispose();
    _descriptionController.dispose();
  }
}
