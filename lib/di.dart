import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:imaginotes/features/notes/ui/blocs/note_bloc/note_bloc.dart';
import 'package:imaginotes/features/notes/ui/blocs/notes_bloc/notes_bloc.dart';
import 'package:imaginotes/features/notes/ui/blocs/tags_bloc/tags_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/ui/blocs/auth_bloc/check_auth_bloc.dart';
import 'features/auth/ui/blocs/created_account_bloc/create_account_bloc.dart';
import 'features/auth/ui/blocs/login_bloc/login_bloc.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/data/repositories/tags_repository_impl.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  getIt.registerFactory(
    () => AuthRepositoryImpl(firebaseAuth: getIt<FirebaseAuth>()),
  );

  getIt.registerFactory(
    () => TagRepositoryImpl(
      auth: getIt<FirebaseAuth>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerFactory(
    () => CheckAuthBloc(repository: getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => NotesRepositoryImpl(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
    ),
  );

  getIt.registerSingleton<NotesBloc>(
    NotesBloc(repository: getIt<NotesRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => CreateAccountBloc(repository: getIt<AuthRepositoryImpl>()),
  );

  getIt.registerSingleton<LoginBloc>(LoginBloc(getIt<AuthRepositoryImpl>()));

  getIt.registerSingleton<TagsBloc>(
    TagsBloc(repository: getIt<TagRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => NoteBloc(repository: getIt<NotesRepositoryImpl>()),
  );
}
