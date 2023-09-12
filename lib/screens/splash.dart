import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';
import 'package:mangakolekt/models/database/library.dart';
import 'package:mangakolekt/util/files.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  // init function to create, load and read any data before opening home page
  Future<void> initApp(BuildContext context) async {
    //generating the theme file if not missing and reading if there
    final themes = await checkThemeFile();

    // loading the themes to the store
    await Future.delayed(const Duration(seconds: 1), () {
      //This is only since the compiler doesnt like async + context so its in a callback
      context.read<ThemeBloc>().add(InitializeTheme(themes: themes, theme: 0));
    });

    await createLogFile();
    await createCurrentDir();
    createAppDB().then((value) {
      Navigator.pushNamed(context, '/home');
      // getCoversFromDir();
    });
  }

  @override
  void initState() {
    initApp(context);
    super.initState();
  }
}
