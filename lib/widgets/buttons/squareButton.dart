import 'package:flutter/material.dart';

class SquareButton extends ElevatedButton {
  SquareButton(
      {super.key,
      required super.onPressed,
      required Widget super.child,
      Color? backgroundColor})
      : super(
          style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
              backgroundColor: WidgetStateProperty.all<Color>(
                  backgroundColor ?? Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ))),
        );
}
