import 'package:flutter/material.dart';

enum BookReadStatus { read, unread }

abstract class DbBookEntety {
  late String name;
  late String path;
}

class BookCover {
  final String name;
  final String path;
  BookCover({required this.name, required this.path});
}

class Book {
  String name;
  Image image;
  BookReadStatus status;
  int read;

  Book(
      {required this.name,
      required this.image,
      required this.status,
      required this.read});
}
