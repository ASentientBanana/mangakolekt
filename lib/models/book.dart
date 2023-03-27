import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
}

class PageEntry {
  final String name;
  final Image image;
  PageEntry({required this.name, required this.image});
}

class Book {
  int pageNumber = 0;
  List<PageEntry> pages = [];
}
