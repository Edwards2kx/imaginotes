// // lib/features/tags/data/repositories/tag_repository_impl.dart

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../domain/entities/tag_entity.dart';
// import '../../domain/repository/tags_repository.dart';

// class TagRepositoryImpl implements TagRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseAuth _auth;

//   TagRepositoryImpl({
//     required FirebaseFirestore firestore,
//     required FirebaseAuth auth,
//   }) : _firestore = firestore,
//        _auth = auth;

//   @override
//   Future<void> saveTag(String tag) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }
//     try {
//       await _firestore
//           .collection('userTags')
//           .doc(user.uid)
//           .collection('tags')
//           .doc()
//           .set({'value': tag});
//     } catch (e) {
//       print('Error al guardar la etiqueta: $e');
//       rethrow;
//     }
//   }

//   @override
//   Stream<List<TagEntity>> getTags() {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }

//     return _firestore.collection('userTags').doc(user.uid).snapshots().map((
//       doc,
//     ) {
//       if (!doc.exists) {
//         return [];
//       }

//       final data = doc.data() as Map<String, dynamic>;
//       return data.entries.map((entry) {
//         return TagEntity.fromJson(entry.value, entry.key);
//       }).toList();
//     });
//   }

//   @override
//   Future<void> updateTag(TagEntity tag) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }

//     final tagDoc = _firestore.collection('userTags').doc(user.uid);

//     return tagDoc.update({tag.id: tag.toJson()});
//   }

//   @override
//   Future<void> deleteTag(String tagId) async {
//     final user = _auth.currentUser;
//     if (user == null) {
//       throw Exception('Usuario no autenticado');
//     }

//     final tagDoc = _firestore.collection('userTags').doc(user.uid);

//     return _firestore.runTransaction((transaction) async {
//       final doc = await transaction.get(tagDoc);

//       if (doc.exists) {
//         transaction.update(tagDoc, {tagId: FieldValue.delete()});
//       }
//     });
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/tag_entity.dart';
import '../../domain/repository/tags_repository.dart';

class TagRepositoryImpl implements TagRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TagRepositoryImpl({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _firestore = firestore,
       _auth = auth;

  @override
  Future<void> saveTag(String tagName) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    try {
      final tagDoc =
          _firestore
              .collection('notes')
              .doc(user.uid)
              .collection('userTags')
              .doc(); // Generar ID automático dentro de userTags

      final tag = TagEntity(id: tagDoc.id, value: tagName);

      await tagDoc.set(tag.toJson()); // Guardar el TagEntity en Firestore
    } catch (e) {
      print('Error al guardar la etiqueta: $e');
      rethrow;
    }
  }

  @override
  Stream<List<TagEntity>> getTags() {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    return _firestore
        .collection('notes')
        .doc(user.uid)
        .collection('userTags')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return TagEntity.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  @override
  Future<void> updateTag(TagEntity tag) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final tagDoc = _firestore
        .collection('notes')
        .doc(user.uid)
        .collection('userTags')
        .doc(tag.id);

    return tagDoc.update(tag.toJson());
  }

  @override
  Future<void> deleteTag(String tagId) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    final tagDoc = _firestore
        .collection('notes')
        .doc(user.uid)
        .collection('userTags')
        .doc(tagId);

    return tagDoc.delete();
  }
}
