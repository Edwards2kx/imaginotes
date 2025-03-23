import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/notes/ui/tags_bloc/tags_bloc.dart';

import '../../domain/entities/tag_entity.dart';

class TagsBottomSheet extends StatefulWidget {
  const TagsBottomSheet({super.key});

  @override
  State<TagsBottomSheet> createState() => _TagsBottomSheetState();
}

class _TagsBottomSheetState extends State<TagsBottomSheet> {
  final List<TagEntity> selectedTags = [];
  final tagController = TextEditingController();

  void onNewTagTapped(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
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
              onPressed: () {
                Navigator.of(context).pop();
              },
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

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4, // Tamaño inicial
      minChildSize: 0.3, // Tamaño mínimo
      maxChildSize: 0.8, // Tamaño máximo
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: BlocBuilder<TagsBloc, TagsState>(
            bloc: getIt<TagsBloc>(),
            builder: (context, state) {
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
                            onPressed: () => onNewTagTapped(context),
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
                              return CheckboxListTile(
                                title: Text(tag.value),
                                value: selectedTags.contains(tag),
                                onChanged: (isChecked) {
                                  setState(() {
                                    isChecked == true
                                        ? selectedTags.add(tag)
                                        : selectedTags.remove(tag);
                                  });
                                },
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
