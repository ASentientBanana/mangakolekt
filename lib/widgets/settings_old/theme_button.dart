import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';
import 'package:mangakolekt/models/bloc/theme.dart';

class ThemeButton extends StatelessWidget {
  final ThemeStore themeStore;
  final int index;

  const ThemeButton({Key? key, required this.index, required this.themeStore})
      : super(key: key);

  void _onTapHandler(BuildContext context) {
    context.read<ThemeBloc>().add(SelectTheme(theme: index));
  }

  @override
  Widget build(BuildContext context) {
    const baseSize = 100.0;
    return InkWell(
      onTap: () => _onTapHandler(context),
      child: SizedBox(
          width: baseSize,
          height: baseSize,
          child: Row(
            children: [
              Container(
                color: themeStore.appbarBackground,
                width: 20,
                height: baseSize,
              ),
              Container(
                color: themeStore.accentColor,
                width: 20,
                height: baseSize,
              ),
              Container(
                color: themeStore.backgroundColor,
                width: 20,
                height: baseSize,
              ),
              Container(
                color: themeStore.appbarBackground,
                width: 20,
                height: baseSize,
              ),
              Container(
                color: themeStore.tertiary,
                width: 20,
                height: baseSize,
              ),
            ],
          )),
    );
  }
}
