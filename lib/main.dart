import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/core/theme/app_theme.dart';
import 'package:imaginotes/firebase_options.dart';

import 'package:imaginotes/features/auth/ui/blocs/auth_bloc/check_auth_bloc.dart';

import 'di.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setup();
  runApp(BlocProvider(create: (_) => getIt<CheckAuthBloc>(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ImagiNotes',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter.config(),
      theme: appTheme(),
      builder: (_, child) {
        return child!;
      },
    );
  }
}
