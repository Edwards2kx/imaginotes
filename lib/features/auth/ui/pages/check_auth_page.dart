import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';

import 'package:imaginotes/features/auth/ui/blocs/auth_bloc/check_auth_bloc.dart';

@RoutePage()
class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<CheckAuthBloc>()..add(const CheckAuthStartEvent()),
      child: Scaffold(
        body: BlocListener<CheckAuthBloc, CheckAuthState>(
          listener: (_, state) {
            if (state is CheckAuthLogged) {
              context.router.replace(const NotesRoute());
            } else if (state is CheckAuthError || state is CheckAuthUnlogged) {
              context.router.replace(LoginRoute());
            }
          },
          child: const Center(child: Text('ImagiNotes')),
        ),
      ),
    );
  }
}
