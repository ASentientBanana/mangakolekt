import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/util/platform.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
  BookCover({
    required this.name,
    required this.path,
    required this.bookPath,
    required this.id,
  });

  String get mapString => "$name;$path;$bookPath";

  // Example path in android:
  // /data/user/0/com.yepex.mangakolekt/app_flutter/mangakolekt/covers/1727543076847446.jpg
  Future<String> getPath() async {
    final appDir = await getGlobalCoversDir();
    final l = [];
    if (isMobile()) {
      final d = Directory(appDir);
      d.list().forEach((elem) {
        l.add(elem);
      });

      final file = join(appDir, basename(path));
      final e = File(file).existsSync();
      final e2 = File(path).existsSync();
      // /data/user/0/com.yepex.mangakolekt/app_flutter/mangakolekt/covers/1727543076861272.jpg: true
      // /data/user/0/com.yepex.mangakolekt/app_flutter/mangakolekt/covers/1727543076861272.jpg: true
      print("");
      print("\n$file: $e");
      print("$path: $e2");
      print("^^^^^^");
      return file;
    }
    return path;
  }

  static BookCover? fromMap(Map<String, dynamic> map) {
    final name = map['name'];
    final path = map['cover'];
    final bookPath = map['path'];
    final id = map['id'];

    if (name == null || path == null || bookPath == null || id == null) {
      return null;
    }

    return BookCover(name: name, path: path, bookPath: bookPath, id: id);
  }

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
  bool isDouble = false;
  // final double w;
  // final double h;

  PageEntry({required this.name, required this.image, required this.isDouble});
}

class Book {
  final int pageNumber;
  final String name;
  final List<PageEntry> pages;
  final String path;
  int? id;

  Book(
      {required this.name,
      required this.pageNumber,
      required this.pages,
      required this.path,
      this.id});

  List<BookPage> getPageList() {
    return pages.asMap().entries.map((e) {
      return BookPage(entry: e.value, index: e.key);
    }).toList();
  }
}

class BookPage {
  PageEntry entry;
  int index;
  BookPage({required this.entry, required this.index});
}

class ReaderPages {}
