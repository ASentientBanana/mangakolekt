import 'package:flutter/services.dart';

const tmpDirName = ".tmp_manga_kolekt";
const tmpBooks = "$tmpDirName/books";
const tmpBook = "$tmpDirName/book";

const appMapFile = "map.txt";

const libFolderName = ".mangakolektLib";
const libFolderCoverFolderName = "covers";
const libFolderMapFile = ".mangakolektion";
const appFolder = "mangakolekt";

const supportedBookTypes = ['cbz'];
const supportedImageTypes = ['png', 'jpeg', 'jpg', 'bmp'];

const logFilePath = ".mangalog.txt";

const themeFileName = "theme.json";

const nextKeyMap = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowUp];

const prevKeyMap = [
  LogicalKeyboardKey.arrowRight,
  LogicalKeyboardKey.arrowDown,
  LogicalKeyboardKey.space
];
