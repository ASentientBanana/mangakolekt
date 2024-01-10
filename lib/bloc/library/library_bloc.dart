import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mangakolekt/models/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';

part 'library_event.dart';
part 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  LibraryBloc()
      : super(LibraryLoaded(libStore: LibStore.initial(), modalPath: '')) {
    on<SetLibs>(_onSetLibs);
    on<SetCover>(_onSetCover);
    on<Reset>(_onReset);
    on<RemoveBook>(_removeBook);
    on<ToggleAddToLibModal>(_toggleModal);
    on<CloseAddToLibModal>(_closeModal);
    on<SearchLib>(_search);
  }

  void _search(SearchLib event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          libStore: state.libStore,
          modalPath: state.modalPath,
          search: event.searchTerm));
    }
  }

  void _closeModal(CloseAddToLibModal event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(libStore: state.libStore, modalPath: ''));
    }
  }

  void _toggleModal(ToggleAddToLibModal event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(libStore: state.libStore, modalPath: event.path));
    }
  }

  void _removeBook(RemoveBook event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          modalPath: state.modalPath,
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
      emit(LibraryLoaded(
          modalPath: (state as LibraryLoaded).modalPath,
          libStore: LibStore.initial()));
    }
  }

  void _onSetLibs(SetLibs event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          modalPath: state.modalPath,
          libStore: LibStore(list: event.libs, cover: state.libStore.cover)));
    }
  }

  void _onSetCover(SetCover event, Emitter<LibraryState> emit) {
    final state = this.state;
    if (state is LibraryLoaded) {
      emit(LibraryLoaded(
          modalPath: state.modalPath,
          libStore:
              LibStore(list: state.libStore.libList, cover: event.cover)));
    }
  }
}
