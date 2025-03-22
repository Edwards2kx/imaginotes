import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';

import '../../domain/repository/notes_repository.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NotesRepository _repository;

  NotesBloc({required NotesRepository repository})
    : _repository = repository,
      super(NotesInitial()) {
    on<LoadNotes>(_loadNotesEvent);
  }
  _loadNotesEvent(LoadNotes event, Emitter<NotesState> emit) async {
    emit(NotesLoading());
    try {
      await emit.forEach<List<NoteEntity>>(
        _repository.getNotes(),
        onData: (notes) => NotesLoaded(notes: [...notes]),
      );
    } catch (e) {
      emit(NotesLoadingError(message: e.toString()));
    }
  }
}
