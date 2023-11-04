import 'package:flutter/material.dart';

enum BookReadStatus { read, unread }

abstract class DbBookEntety {
  late String name;
  late String path;
}

class BookCover {
  late int id;
  String name = '';
  String path = '';
  String bookPath = '';
  BookCover(
      {required this.name,
      required this.path,
      required this.bookPath,
      required this.id});

  String get mapString => "$name;$path;$bookPath";
  // return BookCover(name: bookName, path: out, bookPath: path);

  BookCover.formString(String s) {
    final stringArr = s.split(';');
    name = stringArr[0];
    path = stringArr[1];
    bookPath = stringArr[2];
    id = 1111111;
  }
}

class PageEntry {
  final String name;
  final Image image;
  bool isDouble;
  // final double w;
  // final double h;

  PageEntry({
    required this.name,
    required this.image,
    this.isDouble = false,
    // required this.h,
    // required this.w
  });
}

class Book {
  final int pageNumber;
  final String name;
  final List<PageEntry> pages;
  final String path;

  Book(
      {required this.name,
      required this.pageNumber,
      required this.pages,
      required this.path});
}

class BookPage {
  PageEntry entry;
  int index;
  BookPage({required this.entry, required this.index});
}
