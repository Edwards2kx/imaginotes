// import 'package:flutter/material.dart';

// class PoputMenuItemWithIcon extends PopupMenuItem {
//   final IconData icon;
//   final  title;
//   final Function onTap;
//   const PoputMenuItemWithIcon(
//     this.icon,
//     this.title,
//     this.onTap, {
//     super.key,
//     required super.child,
//   });
// }
import 'package:flutter/material.dart';

class CustomPopupMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;
  final IconData? iconData; // Nuevo parámetro IconData

  const CustomPopupMenuItem({
    super.key,
    required this.value,
    required this.child,
    this.iconData, // El IconData es opcional
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