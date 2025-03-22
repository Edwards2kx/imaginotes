part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {}

final class NotesLoading extends NotesState {}

// final class NotesLoaded extends NotesState {
//   final List<NoteEntity> notes;

//   const NotesLoaded({required this.notes});
// }

final class NotesLoaded extends NotesState {
  final List<NoteEntity> notes;

  const NotesLoaded({required this.notes});

  @override
  List<Object> get props => [notes]; // Incluye la lista de notas en props
}

final class NotesLoadingError extends NotesState {
  final String message;

  const NotesLoadingError({required this.message});
}
