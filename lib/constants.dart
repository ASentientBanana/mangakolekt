import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const tmpDirName = ".tmp_manga_kolekt";
const tmpBooks = "$tmpDirName/books";
const tmpBook = "$tmpDirName/book";

const appMapFile = "map.txt";

const libFolderName = ".mangakolektLib";
const libFolderCoverFolderName = "covers";
const libFolderMapFile = ".mangakolektion";
const appFolder = "mangakolekt";

const dbName = "manga.db";

const supportedBookTypes = ['cbz'];
const supportedImageTypes = ['png', 'jpeg', 'jpg', 'bmp'];

const logFilePath = ".mangalog.txt";

const themeFileName = "theme.json";
const currentFolder = "current";

const prevKeyMap = [LogicalKeyboardKey.arrowLeft, LogicalKeyboardKey.arrowUp];

const nextKeyMap = [
  LogicalKeyboardKey.arrowRight,
  LogicalKeyboardKey.arrowDown,
  LogicalKeyboardKey.space
];

const TextStyle TEXT_STYLE_NORMAL = TextStyle(color: Colors.white);
const TextStyle TEXT_STYLE_DISABLED = TextStyle(color: Colors.grey);

const SIDEBAR_WIDTH = 300.0;
