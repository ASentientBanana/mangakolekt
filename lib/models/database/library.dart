class LibraryEntry {
  final int id;
  final String name;
  final String bookPath;
  LibraryEntry({required this.id, required this.name, required this.bookPath});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'bookPath': bookPath};
  }

  @override
  String toString() {
    return 'LibEntry{id: $id, name:$name, bookPath:$bookPath}';
  }
}
