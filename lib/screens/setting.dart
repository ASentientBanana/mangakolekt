import 'package:flutter/material.dart';

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
            ElevatedButton(
              onPressed: null,
              // onPressed: () => goToThemeCreator(context),
              child: Text("Add new theme"),
            ),
          ],
        ),
      ),
    );
  }
}
