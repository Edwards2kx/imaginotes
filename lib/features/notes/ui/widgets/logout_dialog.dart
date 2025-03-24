import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Estás seguro de que quieres cerrar sesión?'),
      content: const Text('¿Serás redirigido a la página de inicio?'),
      actions: [
        TextButton(
          onPressed: () => context.pop(false),
          child: const Text('No'),
        ),
        FilledButton.tonal(
          onPressed: () => context.pop(true),
          child: const Text('Sí'),
        ),
      ],
    );
  }
}
