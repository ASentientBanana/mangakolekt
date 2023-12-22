import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mangakolekt/models/bloc/theme.dart';

part 'reader_event.dart';
part 'reader_state.dart';

class ReaderBloc extends Bloc<ReaderEvent, ReaderState> {
  ReaderBloc() : super(ThemeLoaded()) {
    // on<UpdateBook>(_onSelectTheme);
  }
}
