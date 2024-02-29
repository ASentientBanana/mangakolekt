import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mangakolekt/models/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/models/library.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryLoaded(libStore: LibStore.initial())) {
    on<SetLibs>(_onSetLibs);
    on<SetCover>(_onSetCover);
    on<Reset>(_onReset);
    on<RemoveBook>(_removeBook);
    on<SearchLib>(_search);
    on<SetCurrentLib>(_onSetCurrentLib);
  }

  void _search(SearchLib event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(libStore: state.libStore, search: event.searchTerm));
    }
  }

  void _removeBook(RemoveBook event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(libStore: LibStore.initial()));
    }
  }

  void _onReset(Reset event, Emitter<LibraryState> emit) {
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(libStore: LibStore.initial()));
    }
  }

  void _onSetLibs(SetLibs event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          libStore:
              LibStore(element: event.libs, index: state.libStore.libIndex)));
    }
  }

  void _onSetCurrentLib(SetCurrentLib event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          libStore: LibStore(
              element: state.libStore.libElements, index: event.index)));
    }
  }

  void _onSetCover(SetCover event, Emitter<LibraryState> emit) {}
}
