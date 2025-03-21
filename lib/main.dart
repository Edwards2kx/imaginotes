import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:imaginotes/features/auth/ui/pages/create_account_page.dart';
import 'package:imaginotes/features/auth/ui/pages/login_bloc/login_bloc.dart';
import 'package:imaginotes/features/auth/ui/pages/login_page.dart';
import 'package:imaginotes/firebase_options.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/ui/pages/created_account_bloc/create_account_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LoginBloc()),
          BlocProvider(create: (_) => CreateAccountBloc()),
        ],
        child: LoginPage(),
      ),
    );
  }
}
