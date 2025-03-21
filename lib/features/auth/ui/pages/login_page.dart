import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/features/auth/ui/pages/created_account_bloc/create_account_bloc.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CreateAccountBloc, CreateAccountState>(
          builder: (context, state) {
            return Column(
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
                ElevatedButton(
                  onPressed: () {
                    context.read<LoginBloc>().add(
                      LoginAttemptEvent(
                        emailController.text,
                        passwordController.text,
                      ),
                    );
                  },
                  child: Text('Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
