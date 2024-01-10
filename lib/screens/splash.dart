// This is to remove waring in the file, the needed checks were added.
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';
import 'package:mangakolekt/models/bloc/theme.dart';
import 'package:mangakolekt/util/database/database_core.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/loadingDog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: LoadingDog(),
      ),
    );
  }

  // init function to create, load and read any data before opening home page
  Future<void> initApp(BuildContext context) async {
    //generating the theme file if not missing and reading if there
    // final themes = await checkThemeFile();

    if (!context.mounted) {
      return;
    }

    await DatabaseCore.initDatabase();

    final mangaList = await DatabaseMangaHelpers.getManga();

    await createCurrentDir();
    // loading the themes to the store

    context
        .read<ThemeBloc>()
        .add(InitializeTheme(themes: [ThemeStore.defaultTheme()], theme: 0));
    if (mangaList != null) {
      context.read<LibraryBloc>().add(SetLibs(libs: mangaList));
    }

    await createLogFile();
    await createAppDB();

    Navigator.pushNamed(context, '/home');
  }

  @override
  void initState() {
    initApp(context);
    super.initState();
  }
}
