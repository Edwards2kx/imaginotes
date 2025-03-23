part of 'note_bloc.dart';

sealed class NoteEvent extends Equatable {
  const NoteEvent();

  @override
  List<Object> get props => [];
}

class SaveNote extends NoteEvent {
  final String title;
  final String content;
  final List<TagEntity> tags;

  const SaveNote({
    required this.title,
    required this.content,
    this.tags = const [],
  });
}

class UpdateNote extends NoteEvent {
  final String title;
  final String content;
  final NoteEntity note;

  const UpdateNote({
    required this.title,
    required this.content,
    required this.note,
  });
}

class LoadNote extends NoteEvent {
  final String id;

  const LoadNote({required this.id});
}

class DeleteNote extends NoteEvent {
  final String id;

  const DeleteNote({required this.id});
}
