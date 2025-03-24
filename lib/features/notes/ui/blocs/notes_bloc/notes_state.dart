part of 'notes_bloc.dart';

sealed class NotesState extends Equatable {
  const NotesState();

  @override
  List<Object> get props => [];
}

final class NotesInitial extends NotesState {}

final class NotesLoading extends NotesState {}

final class NotesLoaded extends NotesState {
  final List<NoteEntity> notes;
  final String filterQuery;
  final Set<String> selectedTags;

  const NotesLoaded({
    required this.notes,
    this.filterQuery = '',
    this.selectedTags = const {},
  });

  @override
  List<Object> get props => [notes, filterQuery, selectedTags];
}

final class NotesLoadingError extends NotesState {
  final String message;

  const NotesLoadingError({required this.message});
}
