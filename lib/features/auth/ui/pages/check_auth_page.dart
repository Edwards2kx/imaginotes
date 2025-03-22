import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:imaginotes/features/auth/ui/pages/check_auth_bloc/check_auth_bloc.dart';

//chequear si hay un token guardado en localStorage para proceder a la pantalla de login o a la pantalla principal
@RoutePage()
class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => CheckAuthBloc(
            repository: AuthRepositoryImpl(firebaseAuth: FirebaseAuth.instance),
          )..add(const CheckAuthStartEvent()),
      child: Scaffold(
        body: BlocListener<CheckAuthBloc, CheckAuthState>(
          listener: (context, state) {
            if (state is CheckAuthLogged) {
              context.router.replace(const NotesRoute());
            } else if (state is CheckAuthError) {
              context.router.replace(LoginRoute());
            }
          },
          child: const Center(child: Text('ImagiNotes')),
        ),
      ),
    );
  }
}
