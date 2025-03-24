import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/tag_entity.dart';
import '../../../domain/repository/tags_repository.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final TagRepository _repository;
  TagsBloc({required TagRepository repository})
    : _repository = repository,
      super(TagsInitial()) {
    on<LoadTags>(_loadTags);
    on<SaveTag>(_saveTag);
    on<DeleteTag>(_deleteTag);
  }

  _loadTags(LoadTags event, Emitter<TagsState> emit) async {
    emit(TagsLoading());
    try {
      await for (final tags in _repository.getTags()) {
        emit(TagsLoaded(tags));
      }
    } catch (e) {
      emit(TagsLoadingError(message: 'Error al cargar las etiquetas'));
    }
  }

  _saveTag(SaveTag event, Emitter<TagsState> emit) async {
    emit(TagsLoading());
    try {
      await _repository.saveTag(event.tagValue);
      // Recargar los tags después de guardar
      add(LoadTags());
    } catch (e) {
      emit(
        TagsLoadingError(
          message: 'Se presentó un error al guardar la etiqueta',
        ),
      );
    }
  }

  _deleteTag(DeleteTag event, Emitter<TagsState> emit) async {
    emit(TagsLoading());
    try {
      await _repository.deleteTag(event.tagId);
      // Recargar los tags después de eliminar
      add(LoadTags());
    } catch (e) {
      emit(
        TagsLoadingError(
          message: 'Se presentó un error al eliminar la etiqueta',
        ),
      );
    }
  }
}
