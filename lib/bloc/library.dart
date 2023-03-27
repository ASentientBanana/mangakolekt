import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/store.dart';

class LibBloc extends Cubit<MangaStore> {
  LibBloc() : super(MangaStore.initial());

  void setPath(BookCover libBook) {
    return emit(MangaStore(cover: libBook, list: state.libList));
  }

  void setLibList(List<BookCover> libList) {
    return emit(MangaStore(cover: state.cover, list: libList));
  }
}
