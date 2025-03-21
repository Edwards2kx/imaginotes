import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imaginotes/features/auth/ui/pages/created_account_bloc/create_account_bloc.dart';


@RoutePage()
class CreateAccountPage extends StatelessWidget {
  CreateAccountPage({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<CreateAccountBloc, CreateAccountState>(
          builder: (context, state) {
            return Column(
              spacing: 20,

              children: <Widget>[
                const Text('Create Account'),
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
                    context.read<CreateAccountBloc>().add(
                      CreateAccountAttempt(
                        emailController.text,
                        passwordController.text,
                      ),
                    );
                  },
                  child: Text('Create Account'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
