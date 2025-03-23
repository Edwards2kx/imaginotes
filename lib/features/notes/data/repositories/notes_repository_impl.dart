// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';

// import '../../domain/repository/notes_repository.dart';

// class NotesRepositoryImpl extends NotesRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;

//   NotesRepositoryImpl({
//     required FirebaseFirestore firestore,
//     required FirebaseAuth auth,
//   }) : _firestore = firestore,
//        _auth = auth;

//   @override
//   Future<void> saveNote({
//     required String title,
//     required String content,
//     List<String>? tags,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }
//     try {
//       final nowTime = DateTime.now();
//       final noteDoc =
//           _firestore.collection('notes').doc(); // Genera un ID automático
//       await noteDoc.set({
//         'userId': user.uid,
//         'title': title,
//         'content': content,
//         'createdAt': nowTime,
//         'updatedAt': nowTime,
//         'tags': tags ?? ['default tag'],
//       });
//     } catch (e) {
//       print('Error al guardar la nota: $e');
//       rethrow; // Re-lanza el error para que el Bloc pueda manejarlo
//     }
//   }

//   @override
//   Stream<List<NoteEntity>> getNotes() {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }

//     return _firestore
//         .collection('notes')
//         .where('userId', isEqualTo: user.uid)
//         .snapshots()
//         .map((snapshot) {
//           return snapshot.docs.map((doc) {
//             final data = doc.data();
//             return NoteEntity(
//               id: doc.id,
//               title: data['title'],
//               content: data['content'],
//               createdAt: (data['createdAt'] as Timestamp).toDate(),
//               updatedAt: (data['updatedAt'] as Timestamp).toDate(),
//               tags:
//                   (data['tags'] as List?)
//                       ?.map((tag) => tag.toString())
//                       .toList() ??
//                   [], // Incluye las etiquetas
//             );
//           }).toList();
//         });
//   }

//   @override
//   Future<void> updateNote(NoteEntity note) {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }

//     return _firestore.collection('notes').doc(note.id).update({
//       'title': note.title,
//       'content': note.content,
//       'updatedAt': DateTime.now(),
//       'tags': note.tags,
//     });
//   }

//   @override
//   Future<void> deleteNoteById(String id) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }
//     return _firestore.collection('notes').doc(id).delete();
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repository/notes_repository.dart';

// class NotesRepositoryImpl extends NotesRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;

//   NotesRepositoryImpl({
//     required FirebaseFirestore firestore,
//     required FirebaseAuth auth,
//   }) : _firestore = firestore,
//        _auth = auth;

//   @override
//   Future<void> saveNote({
//     required String title,
//     required String content,
//     List<String>? tags,
//   }) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }
//     try {
//       final nowTime = DateTime.now();
//       final noteDoc = _firestore.collection('notes').doc();
//       await noteDoc.set({
//         'userId': user.uid,
//         'title': title,
//         'content': content,
//         'createdAt': nowTime,
//         'updatedAt': nowTime,
//         'tags': tags ?? [], // Guardar solo los IDs de los tags
//       });
//     } catch (e) {
//       print('Error al guardar la nota: $e');
//       rethrow;
//     }
//   }

//   @override
//   Stream<List<NoteEntity>> getNotes() {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }

//     return _firestore
//         .collection('notes')
//         .where('userId', isEqualTo: user.uid)
//         .snapshots()
//         .asyncMap((snapshot) async {
//       List<NoteEntity> notes = [];
//       for (var doc in snapshot.docs) {
//         final data = doc.data();
//         List<TagEntity> tagEntities = [];
//         List<String> tagIds = (data['tags'] as List?)?.map((tag) => tag.toString()).toList() ?? [];

//         if (tagIds.isNotEmpty) {
//           final userTagsDoc = await _firestore.collection('userTags').doc(user.uid).get();
//           if (userTagsDoc.exists) {
//             final userTagsData = userTagsDoc.data();
//             if (userTagsData != null) {
//               tagEntities = tagIds.map((tagId) {
//                 final tagData = userTagsData[tagId];
//                 if (tagData != null) {
//                   return TagEntity.fromJson(tagData, tagId);
//                 }
//                 return null;
//               }).whereType<TagEntity>().toList();
//             }
//           }
//         }

//         notes.add(NoteEntity(
//           id: doc.id,
//           title: data['title'],
//           content: data['content'],
//           createdAt: (data['createdAt'] as Timestamp).toDate(),
//           updatedAt: (data['updatedAt'] as Timestamp).toDate(),
//           tags: tagEntities, // Usar la lista de TagEntity
//         ));
//       }
//       return notes;
//     });
//   }
//  @override
//   Future<void> updateNote(NoteEntity note) {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }

//     // Obtener los IDs de los tags de la lista de TagEntity
//     List<String> tagIds = note.tags.map((tag) => tag.id).toList();

//     return _firestore.collection('notes').doc(note.id).update({
//       'title': note.title,
//       'content': note.content,
//       'updatedAt': DateTime.now(),
//       'tags': tagIds, // Guardar solo los IDs de los tags
//     });
//   }

//   @override
//   Future<void> deleteNoteById(String id) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }
//     return _firestore.collection('notes').doc(id).delete();
//   }
// }

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
              .doc(); // Genera un ID automático dentro de userNotes
      await noteDoc.set({
        'title': title,
        'content': content,
        'createdAt': nowTime,
        'updatedAt': nowTime,
        'tags': tags ?? [], // Guardar solo los IDs de los tags
      });
    } catch (e) {
      print('Error al guardar la nota: $e');
      rethrow;
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
        .doc(user.uid)
        .collection('userNotes')
        .snapshots()
        .asyncMap((snapshot) async {
          List<NoteEntity> notes = [];
          for (var doc in snapshot.docs) {
            final data = doc.data();
            List<TagEntity> tagEntities = [];
            List<String> tagIds =
                (data['tags'] as List?)
                    ?.map((tag) => tag.toString())
                    .toList() ??
                [];

            if (tagIds.isNotEmpty) {
              final userTagsDoc =
                  await _firestore
                      .collection('notes')
                      .doc(user.uid)
                      .collection('userTags')
                      .get(); // Obtener todos los tags del usuario
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

    // Obtener los IDs de los tags de la lista de TagEntity
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
          'tags': tagIds, // Guardar solo los IDs de los tags
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
