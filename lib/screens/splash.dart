import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/util/database/database_core.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/loadingDog.dart';
import 'package:permission_handler/permission_handler.dart';

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
  Future<void> initApp() async {
    try {
      if (!context.mounted) {
        return;
      }

      await DatabaseCore.initDatabase();

      if (Platform.isAndroid || Platform.isIOS) {
        final statusses = await [
          Permission.photos,
          Permission.videos,
          Permission.audio,
        ].request();
      }

      final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();
      await createGlobalCoversDir();
      await createCurrentDir();
      // loading the themes to the store
      if (context.mounted) {
        // REFACTOR:
        context.read<LibraryBloc>().add(SetLibs(libs: mangaList));
      }

      await createLogFile();
      await createAppDB();

      if (!context.mounted) return;
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.fixed,
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      );
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initApp();
    });
    super.initState();
  }
}
