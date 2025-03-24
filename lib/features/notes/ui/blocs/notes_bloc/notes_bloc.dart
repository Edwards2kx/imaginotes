import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/note_entity.dart';
import '../../../domain/repository/notes_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _repository;

  NotesBloc({required NotesRepository repository})
    : _repository = repository,
      super(NotesInitial()) {
    on<LoadNotes>(_loadNotesEvent);
    on<SearchNotes>(_searchNotesEvent);
  }

  _loadNotesEvent(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      await emit.forEach<List<NoteEntity>>(
        _repository.getNotes(tags: event.tags),
        onData:
            (notes) =>
                NotesLoaded(notes: [...notes], selectedTags: event.tags ?? {}),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }

  _searchNotesEvent(SearchNotes event, Emitter<NotesState> emit) async {
    // emit(NotesLoading());
    try {
      final notes =
          await _repository.getNotes().first; // Obtiene la lista de notas
      final filteredNotes =
          notes.where((note) {
            return note.title.toLowerCase().contains(
                  event.query.toLowerCase(),
                ) ||
                note.content.toLowerCase().contains(event.query.toLowerCase());
          }).toList();
      emit(NotesLoaded(notes: filteredNotes, filterQuery: event.query));
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }
}
