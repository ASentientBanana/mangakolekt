import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mangakolekt/models/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc() : super(LibraryLoaded(libStore: LibStore.initial())) {
    on<SetLibs>(_onSetLibs);
    on<SetCover>(_onSetCover);
    on<Reset>(_onReset);
    on<RemoveBook>(_removeBook);
  }

  void _removeBook(RemoveBook event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          libStore: LibStore(
              cover: state.libStore.cover.id == event.id
                  ? LibStore.initial().cover
                  : state.libStore.cover,
              list: state.libStore.libList
                  .where((element) => element.id != event.id)
                  .toList())));
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
          libStore: LibStore(list: event.libs, cover: state.libStore.cover)));
    }
  }

  void _onSetCover(SetCover event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          libStore:
              LibStore(list: state.libStore.libList, cover: event.cover)));
    }
  }
}
