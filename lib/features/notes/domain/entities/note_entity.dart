import 'tag_entity.dart';
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

  @override
  String toString() {
    return 'NoteEntity(id: $id, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
