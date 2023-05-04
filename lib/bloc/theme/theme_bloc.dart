import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mangakolekt/models/bloc/theme.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<SelectTheme>(_onSelectTheme);
    on<SetThemes>(_onSetThemes);
  }

  void _onSelectTheme(SelectTheme event, Emitter<ThemeState> emit) {
    if (state is ThemeLoaded) {
      // final _state = state as ThemeLoaded;
      emit(ThemeLoaded(
          themes: (state as ThemeLoaded).themes, theme: event.theme));
    }
  }

  void _onSetThemes(SetThemes event, Emitter<ThemeState> emit) {
    if (state is ThemeLoaded) {
      // final _state = state as ThemeLoaded;
      emit(ThemeLoaded(
          themes: event.themes, theme: (state as ThemeLoaded).theme));
    }
  }
}
