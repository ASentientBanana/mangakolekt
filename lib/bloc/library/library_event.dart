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

class SetLibs extends LibraryEvent {
  final List<BookCover> libs;
  const SetLibs({required this.libs});
  @override
  List<Object> get props => [];
}

class Reset extends LibraryEvent {
  @override
  List<Object> get props => [];
}
