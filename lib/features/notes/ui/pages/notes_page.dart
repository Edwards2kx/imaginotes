import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';

import '../notes_bloc/notes_bloc.dart';

@RoutePage()
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotesBloc>()..add(LoadNotes()),
      child: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesLoadingError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('ImagiNotes'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.router.replace(LoginRoute());
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.router.push(NoteDetailRoute());
            },
            child: Icon(Icons.add),
          ),

          body: _NotesBody(),
        ),
      ),
    );
  }
}

class _NotesBody extends StatefulWidget {
  const _NotesBody();

  @override
  State<_NotesBody> createState() => __NotesBodyState();
}

class __NotesBodyState extends State<_NotesBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotesBloc, NotesState>(
      builder: (context, state) {
        if (state is NotesLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is NotesLoaded) {
          if (state.notes.isEmpty) {
            return const Center(child: Text('No tines notas'));
          }

          return ListView.builder(
            itemCount: state.notes.length,
            itemBuilder: (context, index) {
              final note = state.notes[index];
              return ListTile(
                title: Text(note.title),
                subtitle: Text(note.content),
                onTap: () {
                  context.router.push(NoteDetailRoute(note: note));
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
