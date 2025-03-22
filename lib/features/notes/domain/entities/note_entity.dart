import 'package:imaginotes/features/notes/domain/entities/tag_entity.dart';

class NoteEntity {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<TagEntity> tags;

  NoteEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.tags = const [],
  });

  // @override
  // bool operator ==(Object other) {
  //   if (identical(this, other)) return true;

  //   return other is NoteEntity &&
  //       other.id == id &&
  //       other.title == title &&
  //       other.content == content &&
  //       other.createdAt == createdAt &&
  //       other.updatedAt == updatedAt;
  // }

  // @override
  // int get hashCode {
  //   return id.hashCode ^
  //       title.hashCode ^
  //       content.hashCode ^
  //       createdAt.hashCode ^
  //       updatedAt.hashCode;
  // }

  @override
  String toString() {
    return 'NoteEntity(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  NoteEntity copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<TagEntity>? tags,
  }) {
    return NoteEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
    );
  }
}
