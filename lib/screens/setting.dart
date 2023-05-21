import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/settings/theme_add.dart';
import 'package:mangakolekt/widgets/settings/theme_grid.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void goToThemeCreator(BuildContext context) {
    Navigator.pushNamed(context, '/theme_creator');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ThemeGreed(),
            ElevatedButton(
              onPressed: null,
              // onPressed: () => goToThemeCreator(context),
              child: const Text("Add new theme"),
            ),
          ],
        ),
      ),
    );
  }
}
