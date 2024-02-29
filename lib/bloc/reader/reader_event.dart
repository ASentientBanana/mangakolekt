part of "reader_bloc.dart";

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object> get props => [];
}

class RemoveBookmark extends ReaderEvent {
  final int bookmark;
  const RemoveBookmark({required this.bookmark});
  @override
  List<Object> get props => [];
}

class SetBookmarks extends ReaderEvent {
  final List<int> bookmarks;
  const SetBookmarks({required this.bookmarks});
  @override
  List<Object> get props => [];
}

class ClearBookmarksState extends ReaderEvent {
  @override
  List<Object> get props => [];
}

class UpdateBookmarks extends ReaderEvent {
  @override
  List<Object> get props => [];
}

class UpdateBook extends ReaderEvent {
  final String path;

  const UpdateBook({required this.path});
}
