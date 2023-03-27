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

class Book {
  final String name;
  final String path;
  Book({required this.name, required this.path});
}
