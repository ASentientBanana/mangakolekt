import 'package:flutter/material.dart';

enum BookReadStatus { read, unread }

abstract class DbBookEntety {
  late String name;
  late String path;
}

class BookCover {
  final String name;
  final String path;
  final String bookPath;
  BookCover({required this.name, required this.path, required this.bookPath});
  String get mapString => "$name;$path;$bookPath";
}

class PageEntry {
  final String name;
  final Image image;
  PageEntry({required this.name, required this.image});
}

class Book {
  final int pageNumber;
  final String name;
  final List<PageEntry> pages;
  Book({required this.name, required this.pageNumber, required this.pages});
}
