import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/util/reader.dart';

class ReaderImageContainer extends StatelessWidget {
  ReaderController rc;
  Size size;
  // List<int> pageIndexes = [];
  void Function(DragStartDetails details) onDragStart;
  void Function(DragEndDetails details) onDragEnd;
  void Function() onTap;

  ReaderImageContainer(
      {Key? key,
      required this.rc,
      required this.size,
      required this.onDragStart,
      required this.onDragEnd,
      required this.onTap}) {}

  List<Widget> renderPages(Size size) {
    // A more verbose page rendering way.
    final List<Widget> pages = [];
    final List<int> pageIndexes;
    if (rc.isRightToLeftMode) {
      pageIndexes = rc.getCurrentPages();
    } else {
      pageIndexes = rc.getCurrentPages().reversed.toList();
    }

    final img = rc.pages[pageIndexes[0]].entry.image;
    final w = img.width ?? 1;
    final h = img.height ?? 1;
    final isWide = w > h;

    // Calculate new aspect ratio
    final aspect = isWide ? w / h : h / w;

    double imgWidth;

    if (isWide) {
      imgWidth = size.width;
    } else {
      if (rc.isDoublePageView) {
        imgWidth = size.width / 2;
      } else {
        imgWidth = size.width;
      }
    }

    final imgHeight = imgWidth * aspect;

    for (var i = 0; i < pageIndexes.length; i++) {
      final pageIndex = pageIndexes[i];
      pages.add(
        Image(
          width: imgWidth,
          height: imgHeight,
          // alignment: Alignment.centerRight,
          alignment: getAliment(pageIndexes.length == 2, i),
          image: rc.pages[pageIndex].entry.image.image,
        ),
      );
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onHorizontalDragStart: onDragStart,
      onHorizontalDragEnd: onDragEnd,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: renderPages(size),
      ),
    );
  }
}
