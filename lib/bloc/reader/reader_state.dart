part of 'reader_bloc.dart';

abstract class ReaderState extends Equatable {
  const ReaderState();

  @override
  List<Object> get props => [];
}

class ReaderInitial extends ReaderState {}

class ReaderLoaded extends ReaderState {
  final Book book;
  const ReaderLoaded({required this.book});

  @override
  List<Object> get props => [book];
}

class ReaderLoading extends ReaderState {
  const ReaderLoading();

  @override
  List<Object> get props => [];
}
