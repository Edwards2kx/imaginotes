import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';
import 'package:imaginotes/features/notes/domain/entities/tag_entity.dart';
import 'package:imaginotes/features/notes/domain/repository/notes_repository.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  NoteBloc({required NotesRepository repository})
    : _repository = repository,
      super(NoteInitial()) {
    on<SaveNote>(_saveNoteEvent);
    on<UpdateNote>(_updateNoteEvent);
    on<DeleteNote>(_deleteNoteEvent);
  }
  _saveNoteEvent(SaveNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      final tagsId = event.tags.map((tag) => tag.id).toList();
      await _repository.saveNote(
        title: event.title,
        content: event.content,
        tags: tagsId,
      );
      emit(NoteSaved(message: 'Nota guardada correctamente'));
    } catch (e) {
      emit(NoteSavingError(message: 'Se presentó un error al guardar la nota'));
    }
  }

  _updateNoteEvent(UpdateNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    final noteUpdated = event.note.copyWith(
      title: event.title,
      content: event.content,
    );
    try {
      await _repository.updateNote(noteUpdated);
      emit(NoteSaved(message: 'Nota actualizada correctamente'));
    } catch (e) {
      emit(
        NoteSavingError(message: 'Se presentó un error al actualizar la nota'),
      );
    }
  }

  _deleteNoteEvent(DeleteNote event, Emitter<NoteState> emit) async {
    emit(NoteLoading());
    try {
      await _repository.deleteNoteById(event.id);
      emit(NoteSaved(message: 'Nota eliminada correctamente'));
    } catch (e) {
      emit(
        NoteSavingError(message: 'Se presentó un error al eliminar la nota'),
      );
    }
  }

  final NotesRepository _repository;
}
