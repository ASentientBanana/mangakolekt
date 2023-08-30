import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mangakolekt/models/bloc/reader.dart';
import 'package:mangakolekt/models/util.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc() : super(const ReaderLoading()) {
    on<LoadBook>(_onLoadBook);
    on<ChangeReaderView>(_changeReaderView);
    on<ToggleDoublePageViewMode>(_onToggleDoublePageViewMode);
    on<ToggleScaleTo>(_onToggleScaleTo);
    on<ToggleIsRightToLeftMode>(_onToggleIsRightToLeftMode);
    // on<Increment>(_onIncrement);
    // on<Decrement>(_onDecrement);
  }

// TODO: Handle Increment decrement page events here
//  if i decide to move them to the bloc

  // void _onIncrement(Increment event, Emitter<ReaderState> emit) {
  //   final state = this.state;
  //   if (state is! ReaderLoaded) return;

  //   if (state.bookView.isDoublePageView) {
  //     //Check bounds
  //     // if(state.bookView.)
  //   }
  // }

  // void _onDecrement(Decrement event, Emitter<ReaderState> emit) {}

  void _changeReaderView(ChangeReaderView event, Emitter<ReaderState> emit) {
    final state = this.state;
    if (state is ReaderLoaded) {
      emit(ReaderLoaded(
          bookView: state.bookView.copyWith(readerView: event.readerView)));
    }
  }

  void _onToggleIsRightToLeftMode(
      ToggleIsRightToLeftMode event, Emitter<ReaderState> emit) {
    final state = this.state;
    if (state is ReaderLoaded) {
      emit(ReaderLoaded(
          bookView: state.bookView
              .copyWith(isRightToLeftMode: !state.bookView.isRightToLeftMode)));
    }
  }

  void _onToggleScaleTo(ToggleScaleTo event, Emitter<ReaderState> emit) {
    final state = this.state;
    if (state is ReaderLoaded) {
      emit(ReaderLoaded(
          bookView: state.bookView.copyWith(
              scaleTo: state.bookView.scaleTo == ScaleTo.height
                  ? ScaleTo.width
                  : ScaleTo.height)));
    }
  }

  void _onToggleDoublePageViewMode(
      ToggleDoublePageViewMode event, Emitter<ReaderState> emit) {
    final state = this.state;
    if (state is ReaderLoaded) {
      emit(ReaderLoaded(
          bookView: state.bookView
              .copyWith(isDoublePageView: !state.bookView.isDoublePageView)));
    }
  }

  void _onLoadBook(LoadBook event, Emitter<ReaderState> emit) {
    if (state is ReaderLoading) {
      emit(ReaderLoaded(bookView: event.bookView));
    }
  }
}
