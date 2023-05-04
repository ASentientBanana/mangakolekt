part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}

class SelectTheme extends ThemeEvent {
  final int theme;
  const SelectTheme({required this.theme});
  @override
  List<Object> get props => [];
}

class SetThemes extends ThemeEvent {
  final List<ThemeStore> themes;
  const SetThemes({required this.themes});
  @override
  List<Object> get props => [];
}
