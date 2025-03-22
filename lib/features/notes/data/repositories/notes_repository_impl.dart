import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';

import '../../domain/repository/notes_repository.dart';

class NotesRepositoryImpl extends NotesRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  NotesRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  @override
  Future<void> saveNote({
    required String title,
    required String content,
    List<String>? tags,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
    try {
      final nowTime = DateTime.now();
      final noteDoc =
          _firestore.collection('notes').doc(); // Genera un ID automático
      await noteDoc.set({
        'userId': user.uid,
        'title': title,
        'content': content,
        'createdAt': nowTime,
        'updatedAt': nowTime,
        'tags': tags ?? [],
      });
    } catch (e) {
      // Manejar el error apropiadamente
      print('Error al guardar la nota: $e');
      rethrow; // Re-lanza el error para que el Bloc pueda manejarlo
    }
  }

  @override
  Stream<List<NoteEntity>> getNotes() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    return _firestore
        .collection('notes')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return NoteEntity(
              id: doc.id,
              title: data['title'],
              content: data['content'],
              createdAt: (data['createdAt'] as Timestamp).toDate(),
              updatedAt: (data['updatedAt'] as Timestamp).toDate(),
              // tags:
              //     (data['tags'] as List?)
              //         ?.map((tag) => tag.toString())
              //         .toList() ??
              //     [],
            );
          }).toList();
        });
  }

  @override
  Future<void> updateNote(NoteEntity note) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    return _firestore.collection('notes').doc(note.id).update({
      'title': note.title,
      'content': note.content,
      'updatedAt': DateTime.now(),
      // 'tags': note.tags ?? [],
    });
  }

  @override
  Future<void> deleteNoteById(String id) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
    return _firestore.collection('notes').doc(id).delete();
  }
}
