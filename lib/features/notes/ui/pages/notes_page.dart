import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:imaginotes/core/config/router/app_router.dart';

@RoutePage()
class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ImagiNotes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.router.replace(LoginRoute());
            },
          ),
        ],
      ),
    );
  }
}
