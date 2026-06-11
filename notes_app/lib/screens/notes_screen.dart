import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final List<Note> _extraNotes = [];
  bool _loadingMore = false;
  bool _hasMore = true;

  Future<void> _loadMore() async {
    if (_loadingMore || !_hasMore) return;
    setState(() => _loadingMore = true);

    final newNotes = await _firestoreService.loadMoreNotes();
    setState(() {
      _extraNotes.addAll(newNotes);
      _loadingMore = false;
      if (newNotes.length < 10) _hasMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(children: [Text('📝 '), Text('My Notes')]),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NoteFormScreen()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<Note>>(
        stream: _firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _extraNotes.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          final streamNotes = snapshot.data ?? [];

          final streamIds = streamNotes.map((n) => n.id).toSet();
          final uniqueExtra = _extraNotes
              .where((n) => !streamIds.contains(n.id))
              .toList();

          final allNotes = [...streamNotes, ...uniqueExtra];

          if (allNotes.isEmpty) {
            return const Center(child: Text('No notes yet'));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: allNotes.length + 1,
            itemBuilder: (context, index) {
              if (index == allNotes.length) {
                if (!_hasMore) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: _loadingMore
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _loadMore,
                          child: const Text('Load More'),
                        ),
                );
              }
              return NoteCard(note: allNotes[index]);
            },
          );
        },
      ),
    );
  }
}
