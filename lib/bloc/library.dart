import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/store.dart';

class LibBloc extends Cubit<LibStore> {
  LibBloc() : super(LibStore.initial());

  void setPath(BookCover libBook) {
    return emit(LibStore(cover: libBook, list: state.libList));
  }

  void setLibList(List<BookCover> libList) {
    print("setting");
    return emit(LibStore(cover: state.cover, list: libList));
  }

  void resetPath() {
    return emit(LibStore(
        cover: BookCover(name: '', path: '', bookPath: ''),
        list: state.libList));
  }
}
