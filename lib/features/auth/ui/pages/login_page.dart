import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_router.dart';
import 'package:imaginotes/di.dart';
import 'package:imaginotes/features/auth/ui/pages/login_bloc/login_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginBloc>(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0.1, 0.3, 0.9],
              colors: [Colors.redAccent, Colors.pink, Colors.black26],
            ),
          ),
          child: const _LoginPageBody(),
        ),
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
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(Icons.note_alt, size: 80, color: Colors.white),
              const SizedBox(height: 20),
              Text(
                'Inicio de Sesión',
                style: Theme.of(
                  context,
                ).textTheme.headlineMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white12,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<LoginBloc>().add(
                        LoginAttemptEvent(
                          emailController.text,
                          passwordController.text,
                        ),
                      );
                    },
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
                              style: Theme.of(
                                context,
                              ).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                              ),
                            ),
                  );
                },
              ),
              const SizedBox(height: 10),
              BlocBuilder<LoginBloc, LoginState>(
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
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿No tienes una cuenta?'),
                  TextButton(
                    onPressed: () {
                      context.router.push(RegisterRoute());
                    },
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                    child: Text(
                      'Crear Cuenta',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
