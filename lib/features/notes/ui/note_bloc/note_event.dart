part of 'note_bloc.dart';

sealed class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class SaveNote extends NoteEvent {
  final String title;
  final String content;

  const SaveNote({required this.title, required this.content});
  // final List<TagEntity> tags;
}

class LoadNote extends NoteEvent {
  final String id;

  const LoadNote({required this.id});
}
