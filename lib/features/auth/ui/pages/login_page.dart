import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_constants.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';

import '../../../shared/widgets/linear_gradient_background.dart';
import '../../../shared/widgets/sign_in_textfield.dart';
import '../blocs/login_bloc/login_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: Scaffold(
        body: LinearGradientBackground(child: const _LoginPageBody()),
      ),
    );
  }
}

class _LoginPageBody extends StatefulWidget {
  const _LoginPageBody();

  @override
  State<_LoginPageBody> createState() => _LoginPageBodyState();
}

class _LoginPageBodyState extends State<_LoginPageBody> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          debugPrint('login exitoso');
          context.router.replace(const NotesRoute());
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.formPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderSection(),
              SignInTextField(label: 'Email', controller: emailController),
              const SizedBox(height: 20),
              SignInTextField(
                controller: passwordController,
                label: 'Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 30),
              _ActionButtonSection(
                onTap: () {
                  context.read<LoginBloc>().add(
                    LoginAttemptEvent(
                      emailController.text,
                      passwordController.text,
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              _ErrorSection(),
              const SizedBox(height: 20),
              _SingUpSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtonSection extends StatelessWidget {
  const _ActionButtonSection({this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return ElevatedButton(
          onPressed: state is! LoginLoading ? onTap : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child:
              (state is LoginLoading)
                  ? const CircularProgressIndicator()
                  : Text(
                    'Iniciar Sesión',
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

class _ErrorSection extends StatelessWidget {
  const _ErrorSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state is LoginError) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Error: ${state.errorType.description}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}

class _SingUpSection extends StatelessWidget {
  const _SingUpSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('¿No tienes una cuenta?', style: TextStyle(color: Colors.white70)),
        TextButton(
          onPressed: () {
            context.router.push(SignInRoute());
          },
          style: TextButton.styleFrom(foregroundColor: Colors.white),
          child: Text(
            'Crear Cuenta',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.surface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.note_alt, size: 80, color: Colors.white),
        const SizedBox(height: 20),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
            children: [
              const TextSpan(text: 'Ingresa a '),
              TextSpan(
                text: 'ImagiNotes',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
