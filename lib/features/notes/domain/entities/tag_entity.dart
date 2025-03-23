class TagEntity {
  final String id;
  final String value;

  TagEntity({required this.id, required this.value});

  factory TagEntity.fromJson(Map<String, dynamic> json, String id) {
    return TagEntity(
      id: id,
      value: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': value,
    };
  }
}