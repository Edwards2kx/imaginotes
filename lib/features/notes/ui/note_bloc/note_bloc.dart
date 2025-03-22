import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/features/notes/domain/repository/notes_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc({required NotesRepository repository})
    : _repository = repository,
      super(NoteInitial()) {
    on<SaveNote>(_saveNoteEvent);
  }
  _saveNoteEvent(SaveNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      await _repository.saveNote(title: event.title, content: event.content);
      emit(NoteSaved());
    } catch (e) {
      emit(NoteSavingError(message: e.toString()));
    }
  }

  final NotesRepository _repository;
}
