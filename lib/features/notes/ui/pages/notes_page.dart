import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';

import 'package:imaginotes/core/config/router/app_constants.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/auth/ui/pages/auth_bloc/check_auth_bloc.dart';
import 'package:imaginotes/features/notes/ui/widgets/note_card.dart';

import '../notes_bloc/notes_bloc.dart';
import '../tags_bloc/tags_bloc.dart';

@RoutePage()
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<NotesBloc>()..add(LoadNotes()),
          lazy: false,
        ),
        BlocProvider(
          create: (_) => getIt<TagsBloc>()..add(LoadTags()),
          lazy: false,
        ),
      ],
      child: BlocListener<NotesBloc, NotesState>(
        listener: (context, state) {
          if (state is NotesLoadingError) {
            context.router.replace(const LoginRoute());
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },

        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.router.push(NoteDetailRoute());
            },

            child: const Icon(Icons.add),
          ),

          body: NestedScrollView(
            headerSliverBuilder:
                (_, __) => [
                  SliverAppBar(
                    floating: true,
                    pinned: false,
                    snap: true,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(24.0),
                      child: Padding(
                        padding: const EdgeInsets.all(
                          AppConstants.notesPagePadding,
                        ),
                        child: GestureDetector(
                          onTap: () => context.router.push(SearchRoute()),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(36.0),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.menu),
                                ),
                                const SizedBox(width: 8.0),
                                Expanded(
                                  child: Text(
                                    'Buscar tus notas',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(color: Colors.white70),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    getIt<CheckAuthBloc>().add(Logout());
                                  },
                                  icon: Icon(Icons.logout_outlined),
                                ),

                                const SizedBox(width: 8.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
            body: const _NotesBody(),
          ),
        ),
      ),
    );
  }
}

class _NotesBody extends StatelessWidget {
  const _NotesBody();

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
            padding: const EdgeInsets.all(AppConstants.notesPagePadding),
            itemCount: state.notes.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
        return const SizedBox();
      },
    );
  }
}

@RoutePage()
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
