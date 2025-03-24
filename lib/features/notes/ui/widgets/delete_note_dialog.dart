import 'package:flutter/material.dart';

class DeleteNoteDialog extends StatelessWidget {
  const DeleteNoteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('¿Borrar nota?'),
      content: const Text('¿Estás seguro de que quieres borrar esta nota?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('No'),
        ),
        FilledButton.tonal(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Sí'),
        ),
      ],
    );
  }
}
