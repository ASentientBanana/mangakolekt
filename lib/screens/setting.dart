import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/settings/theme_grid.dart';

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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            ThemeGreed(),
          ],
        ),
      ),
    );
  }
}
