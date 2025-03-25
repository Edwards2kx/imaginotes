import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_constants.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';

import '../../../shared/widgets/linear_gradient_background.dart';
import '../../../shared/widgets/sign_in_textfield.dart';
import '../blocs/created_account_bloc/create_account_bloc.dart';

@RoutePage()
class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt.get<CreateAccountBloc>(),
      child: BlocListener<CreateAccountBloc, CreateAccountState>(
        listener: (context, state) {
          if (state is CreateAccountSuccess) {
            context.router.replaceAll([const NotesRoute()]);
          }
        },
        child: Scaffold(
          body: LinearGradientBackground(child: const _RegisterPageBody()),
        ),
      ),
    );
  }
}

class _RegisterPageBody extends StatefulWidget {
  const _RegisterPageBody();

  @override
  State<_RegisterPageBody> createState() => _RegisterPageBodyState();
}

class _RegisterPageBodyState extends State<_RegisterPageBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _onSignInTap(BuildContext context) {
    context.read<CreateAccountBloc>().add(
      CreateAccountAttempt(
        emailController.text,
        passwordController.text,
        confirmPasswordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.formPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.person_add, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Crear Cuenta',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 30),
            SignInTextField(label: 'Email', controller: emailController),
            const SizedBox(height: 20),
            SignInTextField(
              controller: passwordController,
              label: 'Contraseña',
              obscureText: true,
            ),
            const SizedBox(height: 20),
            SignInTextField(
              controller: confirmPasswordController,
              label: 'Confirmar Contraseña',
              obscureText: true,
            ),
            const SizedBox(height: 30),
            _ActionButtonSection(onTap: () => _onSignInTap(context)),
            const SizedBox(height: 10),
            _ErrorSection(),
          ],
        ),
      ),
    );
  }
}

class _ErrorSection extends StatelessWidget {
  const _ErrorSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (context, state) {
        if (state is CreateAccountError) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Error: ${state.errorMessage}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _ActionButtonSection extends StatelessWidget {
  const _ActionButtonSection({required this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child:
              (state is CreateAccountLoading)
                  ? const CircularProgressIndicator()
                  : Text(
                    'Crear Cuenta',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),
        );
      },
    );
  }
}
