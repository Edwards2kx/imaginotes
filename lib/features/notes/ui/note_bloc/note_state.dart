part of 'note_bloc.dart';

sealed class NoteState extends Equatable {
  const NoteState();

  @override
  List<Object> get props => [];
}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}

final class NoteSaved extends NoteState {
  final String message;

  const NoteSaved({required this.message});
}

final class NoteSavingError extends NoteState {
  final String message;

  const NoteSavingError({required this.message});
}

final class NoteLoaded extends NoteState {
  const NoteLoaded({
    required this.title,
    required this.content,
    required this.updatedAt,
    required this.tags,
  });

  final String title;
  final String content;
  final DateTime updatedAt;
  final List<TagEntity> tags;
}
