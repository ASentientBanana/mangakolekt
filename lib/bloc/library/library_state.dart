part of 'library_bloc.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final LibStore libStore;
  String modalPath;
  String search = '';
  LibraryLoaded(
      {required this.libStore, required this.modalPath, this.search = ''});

  @override
  List<Object> get props => [libStore, modalPath, search];
}

class LibraryLoading extends LibraryState {
  const LibraryLoading();

  @override
  List<Object> get props => [];
}
