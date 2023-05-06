part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  const ThemeState();

  @override
  List<Object> get props => [];
}

class ThemeInitial extends ThemeState {
  final List<ThemeStore> themes = [ThemeStore.defaultTheme()];
  @override
  List<Object> get props => [];
}

class ThemeLoaded extends ThemeState {
  final List<ThemeStore> themes;
  final int theme;

  const ThemeLoaded({required this.themes, required this.theme});

  ThemeStore get activeTheme => themes[theme];

  @override
  List<Object> get props => [themes, theme];
}
