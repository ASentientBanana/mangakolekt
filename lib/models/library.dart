import 'package:mangakolekt/models/book.dart';

class LibraryElement {
  late final String name;
  late final int id;
  late final String path;
  List<BookCover> books = [];
  LibraryElement({required this.id, required this.name, required this.path});

  LibraryElement.empty() {
    name = '';
    id = -1;
  }

  @override
  operator ==(other) =>
      other is LibraryElement && (other.name == name && other.id == id);

  @override
  int get hashCode => Object.hash(name, id, books.length);
}
