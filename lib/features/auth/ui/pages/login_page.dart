import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/core/config/router/app_router.dart';

import 'package:imaginotes/features/auth/ui/pages/login_bloc/login_bloc.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            debugPrint('login exitoso');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          child: Column(
            spacing: 20,
            children: <Widget>[
              const Text('Login'),
              TextField(
                decoration: InputDecoration(labelText: 'Email'),
                controller: emailController,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Password'),
                controller: passwordController,
              ),
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
                    child:
                        (state is LoginLoading)
                            ? CircularProgressIndicator()
                            : Text('Login'),
                  );
                },
              ),

              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  if (state is LoginError) {
                    return Text('Error: ${state.errorType.description}');
                  }
                  return SizedBox();
                },
              ),

              TextButton(
                child: Text('Crear cuenta'),
                onPressed: () {
                  context.router.push(RegisterRoute());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
