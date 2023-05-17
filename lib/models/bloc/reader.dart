import 'package:flutter/material.dart';
import 'package:mangakolekt/models/util.dart';

class BookView {
  bool isDoublePageView = false;
  bool isRightToLeftMode = false;
  final focusNode = FocusNode();
  bool keyPressed = false;
  ScaleTo scaleTo = ScaleTo.height;
  ReaderView readerView = ReaderView.single;

  BookView({
    required this.isDoublePageView,
    required this.isRightToLeftMode,
    required this.scaleTo,
    required this.readerView,
    required bool keyPressed,
  });

  BookView.init({
    isDoublePageView = false,
    this.isRightToLeftMode = false,
    this.scaleTo = ScaleTo.height,
    this.readerView = ReaderView.single,
    bool keyPressed = false,
  });

  BookView copyWith({
    bool? isDoublePageView,
    bool? isRightToLeftMode,
    bool? keyPressed,
    ScaleTo? scaleTo,
    ReaderView? readerView,
  }) {
    return BookView(
      isDoublePageView: isDoublePageView ?? this.isDoublePageView,
      isRightToLeftMode: isRightToLeftMode ?? this.isRightToLeftMode,
      keyPressed: keyPressed ?? this.keyPressed,
      scaleTo: scaleTo ?? this.scaleTo,
      readerView: readerView ?? this.readerView,
    );
  }
}
