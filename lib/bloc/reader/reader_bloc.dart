import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc() : super(ReaderInitial()) {
    on<ReaderEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
