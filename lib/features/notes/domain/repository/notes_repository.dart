import '../entities/note_entity.dart';
abstract class NotesRepository {
  //guardar nota
  Future<void> saveNote({
    required String title,
    required String content,
    List<String>? tags,
  });
  //obtener listado de notas
  Stream<List<NoteEntity>> getNotes({Set<String>? tags});
  //eliminar una nota
  Future<void> deleteNoteById(String id);
  //actualizar una nota
  Future<void> updateNote(NoteEntity note);
}
