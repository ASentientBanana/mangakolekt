part of 'reader_bloc.dart';

abstract class ReaderState extends Equatable {
  const ReaderState();

  @override
  List<Object> get props => [];
}

class ReaderInitial extends ReaderState {}

class ReaderLoaded extends ReaderState {
  final BookView bookView;
  const ReaderLoaded({required this.bookView});

  @override
  List<Object> get props => [bookView];
}

class ReaderLoading extends ReaderState {
  const ReaderLoading();

  @override
  List<Object> get props => [];
}
