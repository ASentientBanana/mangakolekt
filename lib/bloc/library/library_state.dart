part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

class LibraryLoaded extends LibraryState {
  final LibStore libStore;
  String search = '';
  LibraryLoaded({required this.libStore, this.search = ''});

  @override
  List<Object> get props => [libStore, search];
}

class LibraryLoading extends LibraryState {
  const LibraryLoading();

  @override
  List<Object> get props => [];
}
