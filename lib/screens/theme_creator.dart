import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:mangakolekt/models/bloc/theme.dart';

class ThemeCreatorPage extends StatefulWidget {
  const ThemeCreatorPage({super.key});

  @override
  State<ThemeCreatorPage> createState() => _ThemeCreatorPageState();
}

class _ThemeCreatorPageState extends State<ThemeCreatorPage> {
  final defaultTheme = ThemeStore.defaultTheme();
  Color? appbarBackground;
  Color? tertiary;
  Color? accentColor;
  Color? primaryColor;
  Color? backgroundColor;
  Color? textColor;

  @override
  void initState() {
    //if null set default options
    appbarBackground ??= defaultTheme.appbarBackground;
    tertiary ??= defaultTheme.tertiary;
    accentColor ??= defaultTheme.accentColor;
    primaryColor ??= defaultTheme.primaryColor;
    backgroundColor ??= defaultTheme.backgroundColor;
    textColor ??= defaultTheme.textColor;
    super.initState();
  }

  void setAppBar(Color? c) {}
  void setPrimary(Color? c) {}
  void setBackground(Color? c) {}
  void setAccent(Color? c) {}
  void setTetriary(Color? c) {}
  void setText(Color? c) {}

  @override
  build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(child: Text("App Bar")),
                Tab(child: Text("Primary")),
                Tab(child: Text("Background")),
                Tab(child: Text("Accent")),
                Tab(child: Text("Tertiary")),
                Tab(child: Text("Text")),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: Row(
            children: [
              Center(
                child: TabBarView(
                  children: [
                    ColorPicker(
                        pickerColor: appbarBackground!,
                        onColorChanged: setAppBar),
                    ColorPicker(
                        pickerColor: primaryColor!, onColorChanged: setAppBar),
                    ColorPicker(
                        pickerColor: backgroundColor!,
                        onColorChanged: setAppBar),
                    ColorPicker(
                        pickerColor: accentColor!, onColorChanged: setAppBar),
                    ColorPicker(
                        pickerColor: tertiary!, onColorChanged: setAppBar),
                    ColorPicker(
                        pickerColor: textColor!, onColorChanged: setAppBar),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: const Icon(Icons.save),
          ),
        ));
  }
}
