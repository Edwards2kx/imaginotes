import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;
  final IconData? iconData;

  const CustomPopupMenuItem({
    super.key,
    required this.value,
    required this.child,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop<T>(context, value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            if (iconData != null) ...[
              Icon(iconData),
              const SizedBox(width: 16.0),
            ],
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
