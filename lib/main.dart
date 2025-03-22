import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:imaginotes/features/auth/ui/pages/check_auth_bloc/check_auth_bloc.dart';
import 'package:imaginotes/features/auth/ui/pages/login_bloc/login_bloc.dart';

import 'package:imaginotes/firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/ui/pages/created_account_bloc/create_account_bloc.dart';

import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerConfig: appRouter.config(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => CreateAccountBloc()),
            // BlocProvider(
            //   create:
            //       (_) => LoginBloc(
            //         AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance),
            //       ),
            // ),
          ],
          child: child!,
        );
      },
    );
  }
}
