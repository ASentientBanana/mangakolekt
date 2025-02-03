import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  void Function()? onPressed;
  Widget child;
  NavigationItem({super.key, this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorScheme.secondary))),
        child: child,
      ),
    );
  }
}
