import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc() : super(ReaderLoaded(bookmarks: [])) {
    on<UpdateBook>(_updateBook);
    on<RemoveBookmark>(_removeBookmarks);
    on<SetBookmarks>(_setBookmarks);
  }

  _updateBook(UpdateBook event, Emitter<ReaderState> emit) {}
  _updateBookmarks(UpdateBookmarks event, Emitter<ReaderState> emit) {}

  _setBookmarks(SetBookmarks event, Emitter<ReaderState> emit) {
    if (!(this.state is ReaderLoaded)) {
      return;
    }
    emit(ReaderLoaded(bookmarks: event.bookmarks));
  }

  _removeBookmarks(RemoveBookmark event, Emitter<ReaderState> emit) {
    emit(ReaderLoaded(bookmarks: []));
  }

  _clearBookmakrsState(ClearBookmarksState event, Emitter<ReaderState> emit) {}
}
