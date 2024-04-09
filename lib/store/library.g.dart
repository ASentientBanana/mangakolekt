// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LibraryStore on LibraryBase, Store {
  late final _$searchTermAtom =
      Atom(name: 'LibraryBase.searchTerm', context: context);

  @override
  String get searchTerm {
    _$searchTermAtom.reportRead();
    return super.searchTerm;
  }

  @override
  set searchTerm(String value) {
    _$searchTermAtom.reportWrite(value, super.searchTerm, () {
      super.searchTerm = value;
    });
  }

  late final _$selectedCoverIndexAtom =
      Atom(name: 'LibraryBase.selectedCoverIndex', context: context);

  @override
  int get selectedCoverIndex {
    _$selectedCoverIndexAtom.reportRead();
    return super.selectedCoverIndex;
  }

  @override
  set selectedCoverIndex(int value) {
    _$selectedCoverIndexAtom.reportWrite(value, super.selectedCoverIndex, () {
      super.selectedCoverIndex = value;
    });
  }

  late final _$libraryAtom =
      Atom(name: 'LibraryBase.library', context: context);

  @override
  ObservableList<LibraryElement> get library {
    _$libraryAtom.reportRead();
    return super.library;
  }

  @override
  set library(ObservableList<LibraryElement> value) {
    _$libraryAtom.reportWrite(value, super.library, () {
      super.library = value;
    });
  }

  late final _$LibraryBaseActionController =
      ActionController(name: 'LibraryBase', context: context);

  @override
  void setLibrary(List<LibraryElement> lib) {
    final _$actionInfo = _$LibraryBaseActionController.startAction(
        name: 'LibraryBase.setLibrary');
    try {
      return super.setLibrary(lib);
    } finally {
      _$LibraryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void selectCover(int index) {
    final _$actionInfo = _$LibraryBaseActionController.startAction(
        name: 'LibraryBase.selectCover');
    try {
      return super.selectCover(index);
    } finally {
      _$LibraryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void search(String term) {
    final _$actionInfo =
        _$LibraryBaseActionController.startAction(name: 'LibraryBase.search');
    try {
      return super.search(term);
    } finally {
      _$LibraryBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
searchTerm: ${searchTerm},
selectedCoverIndex: ${selectedCoverIndex},
library: ${library}
    ''';
  }
}
