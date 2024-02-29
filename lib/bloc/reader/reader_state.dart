part of 'reader_bloc.dart';

abstract class ReaderState extends Equatable {
  @override
  List<Object> get props => [];
}

class ReaderLoaded extends ReaderState {
  final List<int> bookmarks;
  ReaderLoaded({required this.bookmarks});

  @override
  List<Object> get props => [bookmarks];
}
