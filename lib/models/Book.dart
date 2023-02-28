import 'dart:ffi';

import 'package:flutter/material.dart';

enum BookReadStatus { read, unread }

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
