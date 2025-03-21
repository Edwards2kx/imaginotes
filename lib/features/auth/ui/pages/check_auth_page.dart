import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

//chequear si hay un token guardado en localStorage para proceder a la pantalla de login o a la pantalla principal
@RoutePage()
class CheckAuthPage extends StatelessWidget {
  const CheckAuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('ImagiNotes'),
      ),
    );
  }
}