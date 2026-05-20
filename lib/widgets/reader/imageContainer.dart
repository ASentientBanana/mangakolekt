import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/util/reader.dart';

class ReaderImageContainer extends StatelessWidget {
  ReaderController rc;
  Size size;
  void Function(DragStartDetails details) onDragStart;
  void Function(DragEndDetails details) onDragEnd;
  void Function() onTap;

  ReaderImageContainer(
      {Key? key,
      required this.rc,
      required this.size,
      required this.onDragStart,
      required this.onDragEnd,
      required this.onTap});

  //
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onHorizontalDragStart: onDragStart,
      onHorizontalDragEnd: onDragEnd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: renderPages(rc, size),
      ),
    );
  }
}
