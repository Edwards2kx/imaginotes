import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';
import 'package:imaginotes/features/notes/ui/note_bloc/note_bloc.dart';

import '../tags_bloc/tags_bloc.dart';

@RoutePage()
class NoteDetailPage extends StatelessWidget {
  const NoteDetailPage({super.key, this.note});

  final NoteEntity? note;
  // final String? noteId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NoteBloc>(),
      child: BlocListener<NoteBloc, NoteState>(
        listener: (context, state) {
          if (state is NoteSaved) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.router.pop();
          }
          if (state is NoteSavingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: _NoteDetailBody(note),
      ),
    );
  }
}

class _NoteDetailBody extends StatefulWidget {
  const _NoteDetailBody(this.note);
  final NoteEntity? note;

  @override
  State<_NoteDetailBody> createState() => _NoteDetailBodyState();
}

class _NoteDetailBodyState extends State<_NoteDetailBody> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    if (widget.note != null) {
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _onDeleteAction() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('¿Borrar nota?'),
            content: const Text(
              '¿Estás seguro de que quieres borrar esta nota?',
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
      context.read<NoteBloc>().add(DeleteNote(id: widget.note!.id));
    }
  }

  // Función para mostrar el modal de pantalla completa
  // void _showAddTagsModal(BuildContext context) {}

  void _newTag(BuildContext context) {
    final tagController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar etiqueta'),
          content: TextField(
            controller: tagController,
            onChanged: (value) {
              // TODO: Agregar la etiqueta al modelo
            },
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

  void _showAddTagsModal(BuildContext context) async {
    List<String> selectedTags = []; // Lista de etiquetas seleccionadas

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Para bordes redondeados
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4, // Tamaño inicial
          minChildSize: 0.3, // Tamaño mínimo
          maxChildSize: 0.8, // Tamaño máximo
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: BlocBuilder<TagsBloc, TagsState>(
                bloc: getIt<TagsBloc>(),
                builder: (context, state) {
                  if (state is TagsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TagsLoaded) {
                    return Column(
                      children: [
                        // Barra superior con título y botón de nueva etiqueta
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
                                onPressed: () => _newTag,
                                child: const Text('+ Nueva etiqueta'),
                              ),
                            ],
                          ),
                        ),

                        // Lista de etiquetas con checkboxes
                        if (state.tags.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text('No hay etiquetas disponibles'),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController, // Permite deslizar
                              itemCount: state.tags.length,
                              itemBuilder: (context, index) {
                                final tag = state.tags[index];
                                return CheckboxListTile(
                                  title: Text(tag.value),
                                  value: selectedTags.contains(tag.value),
                                  onChanged: (isChecked) {
                                    if (isChecked == true) {
                                      selectedTags.add(tag.value);
                                    } else {
                                      selectedTags.remove(tag.value);
                                    }
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
      },
    );

    debugPrint('etiquetas seleccionadas: $result cantidad ${result?.length}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Maneja la selección del elemento del menú
              if (value == 'borrar') {
                _onDeleteAction();
              } else if (value == 'compartir') {
              } else if (value == 'etiquetas') {
                _showAddTagsModal(context);
                // _newTag(context);
              }
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  if (widget.note != null)
                    const PopupMenuItem<String>(
                      value: 'borrar',
                      child: Row(
                        spacing: 20,
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.delete_outline), Text('Borrar')],
                      ),
                    ),
                  const PopupMenuItem<String>(
                    value: 'compartir',
                    child: Row(
                      spacing: 20,
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.share_outlined), Text('Compartir')],
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'etiquetas',
                    child: Row(
                      spacing: 20,
                      mainAxisSize: MainAxisSize.min,
                      children: [Icon(Icons.label_outline), Text('Etiquetas')],
                    ),
                  ),
                ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //guarda una nueva nota
          if (widget.note == null) {
            context.read<NoteBloc>().add(
              SaveNote(
                title: titleController.text,
                content: contentController.text,
              ),
            );
          }
          //actualiza una nota existente
          else {
            context.read<NoteBloc>().add(
              UpdateNote(
                title: titleController.text,
                content: contentController.text,
                note: widget.note!,
              ),
            );
          }
        },
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Titulo',
                  border: InputBorder.none,
                ),
                controller: titleController,
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Nota',
                  border: InputBorder.none,
                ),
                controller: contentController,
                maxLines: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
