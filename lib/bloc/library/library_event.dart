part of 'library_bloc.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object> get props => [];
}

class SetCover extends LibraryEvent {
  final BookCover cover;
  const SetCover({required this.cover});
  @override
  List<Object> get props => [];
}

class RemoveBook extends LibraryEvent {
  final int id;
  const RemoveBook({required this.id});

  @override
  List<Object> get props => [];
}

class SetLibs extends LibraryEvent {
  final List<LibraryElement> libs;
  const SetLibs({required this.libs});
  @override
  List<Object> get props => [libs];
}

class SetCurrentLib extends LibraryEvent {
  final int index;
  const SetCurrentLib({required this.index});
  @override
  List<Object> get props => [index];
}

class Reset extends LibraryEvent {
  @override
  List<Object> get props => [];
}

class SearchLib extends LibraryEvent {
  final String searchTerm;
  const SearchLib({required this.searchTerm});
  @override
  List<Object> get props => [searchTerm];
}
