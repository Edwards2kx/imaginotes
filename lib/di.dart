import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:imaginotes/features/auth/data/repositories/auth_repository_impl.dart';

import 'features/auth/ui/pages/check_auth_bloc/check_auth_bloc.dart';

final getIt = GetIt.instance;

void setup() {

  getIt.registerSingleton<FirebaseAuth>(FirebaseAuth.instance);
  
  getIt.registerFactory(
    () => AuthRepositoryImpl(firebaseAuth: getIt<FirebaseAuth>()),
  );

  // Registrar CheckAuthBloc
  getIt.registerFactory(
    () => CheckAuthBloc(repository: getIt<AuthRepositoryImpl>()),
  );
}
