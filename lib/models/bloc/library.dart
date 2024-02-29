import 'package:mangakolekt/models/library.dart';

class LibStore {
  late List<LibraryElement> _libElements;
  int? libIndex;

  List<LibraryElement> get libElements => _libElements;

  LibStore({required List<LibraryElement> element, int? index}) {
    _libElements = element;
    libIndex = index;
  }

  LibStore.initial() {
    _libElements = [];
  }

  // @override
  // operator ==(other) =>
  //     other is LibStore &&
  //     (other.libIndex == libIndex &&
  //         other._libElements.length == _libElements.length);

  // @override
  // int get hashCode => Object.hash(libIndex, _libElements.length);
}
