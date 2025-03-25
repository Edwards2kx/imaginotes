import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/note_entity.dart';
import '../../domain/entities/tag_entity.dart';
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
          _firestore
              .collection('notes')
              .doc(user.uid)
              .collection('userNotes')
              .doc();
      await noteDoc.set({
        'title': title,
        'content': content,
        'createdAt': nowTime,
        'updatedAt': nowTime,
        'tags': tags ?? [],
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al guardar la nota: $e');
      }
      rethrow;
    }
  }

  @override
  Stream<List<NoteEntity>> getNotes({Set<String>? tags}) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    Query<Map<String, dynamic>> query = _firestore
        .collection('notes')
        .doc(user.uid)
        .collection('userNotes');

    if (tags != null && tags.isNotEmpty) {
      // Filtrar notas que contengan al menos uno de los tags
      query = query.where('tags', arrayContainsAny: tags.toList());
    }

    return query.snapshots().asyncMap((snapshot) async {
      List<NoteEntity> notes = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        List<TagEntity> tagEntities = [];
        List<String> tagIds =
            (data['tags'] as List?)?.map((tag) => tag.toString()).toList() ??
            [];

        if (tagIds.isNotEmpty) {
          final userTagsDoc =
              await _firestore
                  .collection('notes')
                  .doc(user.uid)
                  .collection('userTags')
                  .get();
          if (userTagsDoc.docs.isNotEmpty) {
            Map<String, dynamic> userTagsData = {};
            for (var tagDoc in userTagsDoc.docs) {
              userTagsData[tagDoc.id] = tagDoc.data();
            }
            tagEntities =
                tagIds
                    .map((tagId) {
                      final tagData = userTagsData[tagId];
                      if (tagData != null) {
                        return TagEntity.fromJson(tagData, tagId);
                      }
                      return null;
                    })
                    .whereType<TagEntity>()
                    .toList();
          }
        }

        notes.add(
          NoteEntity(
            id: doc.id,
            title: data['title'],
            content: data['content'],
            createdAt: (data['createdAt'] as Timestamp).toDate(),
            updatedAt: (data['updatedAt'] as Timestamp).toDate(),
            tags: tagEntities, // Usar la lista de TagEntity
          ),
        );
      }
      return notes;
    });
  }

  @override
  Future<void> updateNote(NoteEntity note) {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    List<String> tagIds = note.tags.map((tag) => tag.id).toList();

    return _firestore
        .collection('notes')
        .doc(user.uid)
        .collection('userNotes')
        .doc(note.id)
        .update({
          'title': note.title,
          'content': note.content,
          'updatedAt': DateTime.now(),
          'tags': tagIds,
        });
  }

  @override
  Future<void> deleteNoteById(String id) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }
    return _firestore
        .collection('notes')
        .doc(user.uid)
        .collection('userNotes')
        .doc(id)
        .delete();
  }
}
