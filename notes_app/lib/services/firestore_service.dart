import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Note>> getNotes() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            _lastDocument = snapshot.docs.last;
          }
          return snapshot.docs.map((doc) {
            return Note.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  Future<void> createNote(String title, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore.collection('users').doc(user.uid).collection('notes').add({
      'title': title,
      'content': content,
      'userId': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote(String noteId, String title, String content) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(noteId)
        .update({
          'title': title,
          'content': content,
          'updatedAt': FieldValue.serverTimestamp(),
        });
  }

  Future<void> deleteNote(String noteId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('User not logged in');

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(noteId)
        .delete();
  }

  DocumentSnapshot? _lastDocument;
  static const int _pageSize = 10;

  Future<List<Note>> loadMoreNotes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    Query query = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .limit(_pageSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      _lastDocument = snapshot.docs.last;
    }

    return snapshot.docs.map((doc) {
      return Note.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  void resetPagination() {
    _lastDocument = null;
  }
}
