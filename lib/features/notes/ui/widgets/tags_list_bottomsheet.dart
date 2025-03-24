import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';

import '../../domain/entities/tag_entity.dart';
import '../blocs/notes_bloc/notes_bloc.dart';
import '../blocs/tags_bloc/tags_bloc.dart';

class TagsBottomSheet extends StatefulWidget {
  const TagsBottomSheet({super.key, this.selectedTags = const []});

  final List<TagEntity> selectedTags;

  @override
  State<TagsBottomSheet> createState() => _TagsBottomSheetState();
}

class _TagsBottomSheetState extends State<TagsBottomSheet> {
  final List<TagEntity> selectedTags = [];
  final tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedTags.addAll(widget.selectedTags);
  }

  void onNewTagTapped() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Agregar etiqueta'),
          content: TextField(
            controller: tagController,
            decoration: const InputDecoration(
              hintText: 'Nombre de la etiqueta',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (tagController.text.isEmpty) return;
                getIt<TagsBloc>().add(SaveTag(tagValue: tagController.text));
                context.pop();
              },
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDeleteTagAction(String tagId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('¿Deseas borar la etiqueta?'),
            content: const Text(
              'Será necesario volver a cargar las notas despues de la eliminación de la etiqueta',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Sí'),
              ),
            ],
          ),
    );
    if (confirm == true && mounted) {
      getIt<TagsBloc>().add(DeleteTag(tagId: tagId));
      //Recargar las notas para remover las etiquetas eliminadas
      getIt<NotesBloc>().add(LoadNotes());
      context.router.popUntil(
        (route) => route.settings.name == NotesRoute.name,
      );
    }
  }

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: BlocBuilder<TagsBloc, TagsState>(
            bloc: getIt<TagsBloc>(),
            builder: (_, state) {
              if (state is TagsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TagsLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Escoge las etiquetas...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () => onNewTagTapped(),
                            child: const Text('+ Nueva etiqueta'),
                          ),
                        ],
                      ),
                    ),

                    // Lista de etiquetas con checkboxes
                    state.tags.isEmpty
                        ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text('No hay etiquetas disponibles'),
                        )
                        : Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: state.tags.length,
                            itemBuilder: (context, index) {
                              final tag = state.tags[index];
                              return Row(
                                children: [
                                  IconButton(
                                    onPressed: () => _onDeleteTagAction(tag.id),
                                    icon: Icon(Icons.delete_forever_outlined),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: CheckboxListTile(
                                      title: Text(tag.value),
                                      value: selectedTags.any(
                                        (selTag) => selTag.id == tag.id,
                                      ),
                                      // value: selectedTags.contains(tag),
                                      onChanged: (isChecked) {
                                        setState(() {
                                          if (isChecked == true) {
                                            if (!selectedTags.any(
                                              (selTag) => selTag.id == tag.id,
                                            )) {
                                              selectedTags.add(tag);
                                            }
                                          } else {
                                            selectedTags.removeWhere(
                                              (selTag) => selTag.id == tag.id,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                    // Botón de confirmación
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(selectedTags);
                        },
                        child: const Text('Listo'),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        );
      },
    );
  }
}
