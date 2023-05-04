import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';
import 'package:mangakolekt/models/bloc/theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        automaticallyImplyLeading: false,
      ),
      // bottomNavigationBar: BottomNavigationBar(items: const [
      //   BottomNavigationBarItem(icon: Icon(Icons.settings_rounded))
      // ]),
      body: Column(children: [
        BlocBuilder<ThemeBloc, ThemeState>(builder: (context, state) {
          final List<ThemeStore> themes;
          if (state is ThemeLoaded) {
            themes = state.themes;
          } else {
            themes = (state as ThemeInitial).themes;
          }
          return Row(
            children: themes.map((e) => Text(e.toString())).toList(),
          );
        })
      ]),
    );
  }
}
