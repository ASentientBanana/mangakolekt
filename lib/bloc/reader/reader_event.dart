part of "reader_bloc.dart";

abstract class ReaderEvent extends Equatable {
  const ReaderEvent();

  @override
  List<Object> get props => [];
}

class UpdateBook extends ReaderEvent {
  final String path;

  const UpdateBook({required this.path});
}
