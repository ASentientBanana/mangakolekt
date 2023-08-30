part of 'reader_bloc.dart';

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();
  @override
  List<Object> get props => [];
}

class LoadBook extends ReaderEvent {
  final BookView bookView;
  const LoadBook({required this.bookView});
  @override
  List<Object> get props => [];
}

class ChangeReaderView extends ReaderEvent {
  final ReaderView readerView;
  const ChangeReaderView({required this.readerView});
  @override
  List<Object> get props => [];
}

class ToggleDoublePageViewMode extends ReaderEvent {
  @override
  List<Object> get props => [];
}

class ToggleIsRightToLeftMode extends ReaderEvent {
  @override
  List<Object> get props => [];
}

class ToggleScaleTo extends ReaderEvent {
  @override
  List<Object> get props => [];
}

//NOTE: WIP, not sure if smart

class Increment extends ReaderEvent {
  @override
  List<Object> get props => [];
}

class Decrement extends ReaderEvent {
  @override
  List<Object> get props => [];
}
