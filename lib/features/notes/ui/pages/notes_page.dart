import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:imaginotes/core/config/router/app_constants.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/auth/ui/pages/auth_bloc/check_auth_bloc.dart';
import 'package:imaginotes/features/notes/ui/widgets/logout_dialog.dart';
import 'package:imaginotes/features/notes/ui/widgets/note_card.dart';

import '../blocs/notes_bloc/notes_bloc.dart';
import '../blocs/tags_bloc/tags_bloc.dart';

@RoutePage()
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  void _onAddTap(BuildContext context) {
    context.router.push(NoteDetailRoute());
  }

  void _onSearchTap(BuildContext context) {
    context.router.push(SearchRoute());
  }

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 4),
                content: Text(state.message),
                action: SnackBarAction(
                  label: 'Reintentar',
                  onPressed: () {
                    context.read<NotesBloc>().add(LoadNotes());
                  },
                ),
              ),
            );
          }
        },

        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () => _onAddTap(context),
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
                          onTap: () => _onSearchTap(context),
                          child: _AppBarInternal(),
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

        if (state is NotesLoadingError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error al cargar notas ☹️',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => context.read<NotesBloc>().add(LoadNotes()),
                  child: Text(
                    'Reintentar',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
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

class _AppBarInternal extends StatelessWidget {
  const _AppBarInternal();

  void _onLogoutTap(BuildContext context) async {
    final response = await showDialog<bool?>(
      context: context,
      builder: (_) => const LogoutDialog(),
    );

    if (response == true) getIt<CheckAuthBloc>().add(Logout());
  }

  void _onMenuTap(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(36.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Row(
          children: [
            IconButton(
              onPressed: () => _onMenuTap(context),
              icon: Icon(Icons.menu),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                'Buscar tus notas',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: Colors.white70),
              ),
            ),
            IconButton(
              onPressed: () => _onLogoutTap(context),
              icon: Icon(Icons.logout_outlined),
            ),
            const SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}
