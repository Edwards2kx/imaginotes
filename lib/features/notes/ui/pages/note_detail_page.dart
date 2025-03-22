import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/notes/domain/entities/note_entity.dart';
import 'package:imaginotes/features/notes/ui/note_bloc/note_bloc.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Nota guardada correctamente')),
            );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
