import 'dart:convert';

class TagEntity {
  final String tagName;

  TagEntity({required this.tagName});

  TagEntity copyWith({String? tagName}) {
    return TagEntity(tagName: tagName ?? this.tagName);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'tagName': tagName};
  }

  factory TagEntity.fromMap(Map<String, dynamic> map) {
    return TagEntity(tagName: map['tagName'] as String);
  }

  String toJson() => json.encode(toMap());

  factory TagEntity.fromJson(String source) =>
      TagEntity.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TagEntity(tagName: $tagName)';
}
