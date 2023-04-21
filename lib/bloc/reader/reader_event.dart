part of 'reader_bloc.dart';

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object> get props => [];
}

class LoadBook extends ReaderEvent {
  const LoadBook();

  @override
  List<Object> get props => [];
}

class OpenBook extends ReaderEvent {}

class NextPage extends ReaderEvent {}

class PrevPage extends ReaderEvent {}

class ChangeReaderPageView extends ReaderEvent {}

// class PrevPage extends ReaderEvent{}
// class PrevPage extends ReaderEvent{}
// class PrevPage extends ReaderEvent{}
