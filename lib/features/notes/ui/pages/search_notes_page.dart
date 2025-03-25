
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:imaginotes/core/config/router/app_constants.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/notes/ui/blocs/notes_bloc/notes_bloc.dart';

import '../widgets/note_card.dart';

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Buscar notas',
            border: InputBorder.none,
          ),
          onChanged: (value) => getIt<NotesBloc>().add(SearchNotes(value)),
        ),
      ),
      body: BlocBuilder<NotesBloc, NotesState>(
        bloc: getIt<NotesBloc>(),
        builder: (context, state) {
          if (state is NotesLoaded && state.notes.isNotEmpty) {
            return MasonryGridView.builder(
              padding: const EdgeInsets.all(AppConstants.notesPagePadding),
              itemCount: state.notes.length,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
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
          return const Center(child: Text('No hay notas coincidentes'));
        },
      ),
    );
  }
}
