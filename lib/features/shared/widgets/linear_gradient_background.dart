import 'package:flutter/material.dart';

class LinearGradientBackground extends StatelessWidget {
  final Widget? child;

  const LinearGradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.1, 0.3, 0.9],
          colors: [Colors.redAccent, Colors.pink, Colors.black26],
        ),
      ),
      child: child,
    );
  }
}
