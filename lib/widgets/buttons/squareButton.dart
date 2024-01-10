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
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(
                  backgroundColor ?? Colors.white),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ))),
        );
}
