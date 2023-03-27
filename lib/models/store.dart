import 'package:mangakolekt/models/book.dart';

class MangaStore {
  BookCover _cover = BookCover(name: "", path: "", bookPath: "");
  List<BookCover> _libList = [];

  BookCover get cover => _cover;
  List<BookCover> get libList => _libList;

  MangaStore({required BookCover cover, required List<BookCover> list}) {
    _cover = cover;
    _libList = list;
  }

  MangaStore.initial() {
    _cover = BookCover(name: "", path: "", bookPath: "");
    _libList = [];
  }
}
