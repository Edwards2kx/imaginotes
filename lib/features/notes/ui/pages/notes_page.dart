import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:imaginotes/core/config/router/app_constants.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/notes/ui/widgets/note_card.dart';

import '../notes_bloc/notes_bloc.dart';

// const double _kSpacing = 8.0;

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
            // ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56.0),
              //genera un nuevo contexto con el bloc en el arbol de widgets
              child: Builder(
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(AppConstants.notesPagePadding),
                    child: TextField(
                      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                      autofocus: false,
                      decoration: const InputDecoration(
                        labelText: 'Buscar notas',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        context.read<NotesBloc>().add(SearchNotes(value));
                      },
                    ),
                  );
                },
              ),
            ),
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
            return const Center(child: Text('No tienes notas'));
          }

          return MasonryGridView.builder(
            itemCount: state.notes.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columnas
            ),
            itemBuilder: (context, index) {
              final note = state.notes[index];

              return NoteCard(
                note: note,
                searchQuery: state.filterQuery,
                onTap: () => context.router.push(NoteDetailRoute(note: note)),
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
