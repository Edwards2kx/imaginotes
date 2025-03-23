// part of 'notes_bloc.dart';

// sealed class NotesEvent extends Equatable {
//   const NotesEvent();

//   @override
//   List<Object> get props => [];
// }

// class LoadNotes extends NotesEvent {}


part of 'notes_bloc.dart';

sealed class NotesEvent extends Equatable {
  const NotesEvent();

  @override
  List<Object> get props => [];
}

class LoadNotes extends NotesEvent {}

class SearchNotes extends NotesEvent {
  final String query;

  const SearchNotes(this.query);

  @override
  List<Object> get props => [query];
}