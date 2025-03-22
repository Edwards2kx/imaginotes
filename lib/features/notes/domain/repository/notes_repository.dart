import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';

abstract class NotesRepository {
  //guardar nota
  Future<void> saveNote({
    required String title,
    required String content,
    List<String>? tags,
  });
  // Future<void> saveNote(NoteEntity note);

  //obtener nota por id
  //obtener listado de notas
  Stream<List<NoteEntity>> getNotes();
  //filtrar notas por categoría
  //eliminar una nota
  //actualizar una nota
}
