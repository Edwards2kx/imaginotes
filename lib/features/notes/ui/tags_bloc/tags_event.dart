part of 'tags_bloc.dart';

sealed class TagsEvent extends Equatable {
  const TagsEvent();

  @override
  List<Object> get props => [];
}

class LoadTags extends TagsEvent {}

class SaveTag extends TagsEvent {
  final String tagValue;

  const SaveTag({required this.tagValue});
}

class UpdateTag extends TagsEvent {
  final TagEntity tagEntity;
  final String tagValue;

  const UpdateTag({required this.tagEntity, required this.tagValue});
}

class DeleteTag extends TagsEvent {
  final String tagId;
  const DeleteTag({required this.tagId});
}

