import 'package:flutter/material.dart';

class SquareButton extends ElevatedButton {
  SquareButton(
      {Key? key,
      required void Function()? onPressed,
      required Widget child,
      Color? backgroundColor})
      : super(
          key: key,
          onPressed: onPressed,
          child: child,
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
