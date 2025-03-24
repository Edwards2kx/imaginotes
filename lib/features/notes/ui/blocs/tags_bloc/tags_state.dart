part of 'tags_bloc.dart';

sealed class TagsState extends Equatable {
  const TagsState();

  @override
  List<Object> get props => [];
}

final class TagsInitial extends TagsState {}

class TagsLoading extends TagsState {}

class TagsLoaded extends TagsState {
  final List<TagEntity> tags;

  const TagsLoaded(this.tags);

  @override
  List<Object> get props => [tags];
}

class TagsLoadingError extends TagsState {
  final String message;

  const TagsLoadingError({required this.message});

  @override
  List<Object> get props => [message];
}
