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
  // const ChangeReaderView ();

  @override
  List<Object> get props => [];
}

// class PrevPage extends ReaderEvent{}
