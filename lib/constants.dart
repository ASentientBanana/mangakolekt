import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const appMapFile = "map.txt";

// const libFolderName = ".mangakolektLib";
// const libFolderCoverFolderName = "covers";
// const libFolderMapFile = ".mangakolektion";
// const appFolder = "mangakolekt";

// const dbName = "manga.db";

const supportedBookTypes = ['cbz'];
const supportedImageTypes = ['png', 'jpeg', 'jpg', 'bmp'];

const logFilePath = ".mangalog.txt";

const prevKeyMap = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowUp];

const nextKeyMap = [
  LogicalKeyboardKey.arrowRight,
  LogicalKeyboardKey.arrowDown,
  LogicalKeyboardKey.space
];

const TextStyle TEXT_STYLE_NORMAL = TextStyle(color: Colors.white);
const TextStyle TEXT_STYLE_DISABLED = TextStyle(color: Colors.grey);

const SIDEBAR_WIDTH = 200.0;

class MangaColors {
  static const primary = Color(0xFF244769);
  static const secondary = Color(0xFFb5d1f1);
  static const error = Color(0xFF244769);
  static const background = Color(0xFF081822);
  static const surface = Color(0xFF081822);
  static const onSurface = Color(0xFFeef5ee);
  static const tertiary = Color(0xFFc1cc9c);
}
