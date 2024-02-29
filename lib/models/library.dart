import 'package:mangakolekt/models/book.dart';

class LibraryElement {
  late final String name;
  late final int id;
  List<BookCover> books = [];
  LibraryElement({required this.id, required this.name});

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
