// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../domain/entities/tag_entity.dart';
// import '../../domain/repository/tags_repository.dart';

// part 'tags_event.dart';
// part 'tags_state.dart';

// class TagsBloc extends Bloc<TagsEvent, TagsState> {
//   final TagRepository _repository;
//   TagsBloc({required TagRepository repository})
//     : _repository = repository,
//       super(TagsInitial()) {
//     on<LoadTags>(_loadTags);
//     on<SaveTag>(_saveTag);
//   }

//   _loadTags(LoadTags event, Emitter<TagsState> emit) async {
//     emit(TagsLoading());
//     _repository.getTags().listen((tags) {
//       emit(TagsLoaded(tags));
//     });
//   }

//   _saveTag(SaveTag event, Emitter<TagsState> emit) async {
//     emit(TagsLoading());
//     try {
//       await _repository.saveTag(
//         TagEntity(id: event.tagValue, value: event.tagValue),
//       );
//       //luego se modifica al escuchar el stream
//       emit(TagsInitial());
//     } catch (e) {
//       emit(
//         TagsLoadingError(
//           message: 'Se presentó un error al guardar la etiqueta',
//         ),
//       );
//     }
//   }
// }

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/tag_entity.dart';
import '../../domain/repository/tags_repository.dart';

part 'tags_event.dart';
part 'tags_state.dart';

class TagsBloc extends Bloc<TagsEvent, TagsState> {
  final TagRepository _repository;
  TagsBloc({required TagRepository repository})
    : _repository = repository,
      super(TagsInitial()) {
    on<LoadTags>(_loadTags);
    on<SaveTag>(_saveTag);
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
      await _repository.saveTag(
        event.tagValue,
        // TagEntity(
        //   id: event.tagValue,
        //   value: event.tagValue,
        // ), // Usa 'name' en lugar de 'value'
      );
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
}
