import '../entities/tag_entity.dart';

abstract class TagRepository {
  Future<void> saveTag(String tag);
  Stream<List<TagEntity>> getTags();
  Future<void> updateTag(TagEntity tag);
  Future<void> deleteTag(String tagId);
}
