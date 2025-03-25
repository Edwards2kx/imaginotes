import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
              .doc();

      final tag = TagEntity(id: tagDoc.id, value: tagName);

      await tagDoc.set(tag.toJson());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error al guardar la etiqueta: $e');
      }
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
