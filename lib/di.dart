import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:imaginotes/features/notes/ui/note_bloc/note_bloc.dart';
import 'package:imaginotes/features/notes/ui/notes_bloc/notes_bloc.dart';

import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/ui/pages/check_auth_bloc/check_auth_bloc.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  getIt.registerSingleton<FirebaseFirestore>(FirebaseFirestore.instance);

  getIt.registerFactory(
    () => AuthRepositoryImpl(firebaseAuth: getIt<FirebaseAuth>()),
  );

  // Registrar CheckAuthBloc
  getIt.registerFactory(
    () => CheckAuthBloc(repository: getIt<AuthRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => NotesRepositoryImpl(
      firestore: getIt<FirebaseFirestore>(),
      auth: getIt<FirebaseAuth>(),
    ),
  );

  // getIt.registerFactory(
  //   () => NotesBloc(repository: getIt<NotesRepositoryImpl>()),
  // );
  // getIt.registerSingleton<NotesBloc>(FirebaseAuth.instance);
  getIt.registerSingleton<NotesBloc>(
    NotesBloc(repository: getIt<NotesRepositoryImpl>()),
  );

  getIt.registerFactory(
    () => NoteBloc(repository: getIt<NotesRepositoryImpl>()),
  );
}
