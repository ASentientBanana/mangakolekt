import 'package:flutter/material.dart';
import 'package:mangakolekt/models/util.dart';

enum BookReadStatus { read, unread }

abstract class DbBookEntety {
  late String name;
  late String path;
}

class BookCover {
  String name = '';
  String path = '';
  String bookPath = '';
  BookCover({required this.name, required this.path, required this.bookPath});

  String get mapString => "$name;$path;$bookPath";
  // return BookCover(name: bookName, path: out, bookPath: path);

  BookCover.formString(String s) {
    final stringArr = s.split(';');
    name = stringArr[0];
    path = stringArr[1];
    bookPath = stringArr[2];
  }
}

class PageEntry {
  final String name;
  final Image image;
  PageEntry({required this.name, required this.image});
}

class OldBook {
  final int pageNumber;
  final String name;
  final List<PageEntry> pages;

  OldBook({required this.name, required this.pageNumber, required this.pages});
}

class Book {
  final int pageNumber;
  final String name;
  final List<PageEntry> pages;

  int? numberOfPages = 0;
  bool? isDoublePageView = false;
  bool? isRightToLeftMode = false;
  List<BookPage>? currentPages = [];
  final focusNode = FocusNode();
  bool keyPressed = false;
  ScaleTo? scaleTo = ScaleTo.height;

  Book({
    required this.pageNumber,
    required this.name,
    required this.pages,
    this.numberOfPages,
    this.isDoublePageView,
    this.isRightToLeftMode,
    this.currentPages,
    this.scaleTo,
    required bool keyPressed,
  });

  Book.init({
    this.pageNumber = 1,
    this.name = '',
    this.pages = const [],
  });

  Book copyWith({
    int? pageNumber,
    String? name,
    List<PageEntry>? pages,
    int? numberOfPages,
    bool? isDoublePageView,
    bool? isRightToLeftMode,
    List<BookPage>? currentPages,
    bool? keyPressed,
    ScaleTo? scaleTo,
  }) {
    return Book(
      pageNumber: pageNumber ?? this.pageNumber,
      name: name ?? this.name,
      pages: pages ?? this.pages,
      numberOfPages: numberOfPages ?? this.numberOfPages,
      isDoublePageView: isDoublePageView ?? this.isDoublePageView,
      isRightToLeftMode: isRightToLeftMode ?? this.isRightToLeftMode,
      currentPages: currentPages ?? this.currentPages,
      keyPressed: keyPressed ?? this.keyPressed,
      scaleTo: scaleTo ?? this.scaleTo,
    );
  }
}

class BookPage {
  PageEntry entry;
  int index;
  BookPage({required this.entry, required this.index});
}
