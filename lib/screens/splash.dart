import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/initializer.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/database/databaseHelpers.dart';
import 'package:mangakolekt/widgets/loadingDog.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _navigationService = locator<NavigationService>();

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
      //Register documents path

      if (!(await initPermissions())) {
        // TODO: Add flow
      }
      await initAppStructure();
      final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();

      // loading the themes to the store
      if (context.mounted) {
        // REFACTOR:
        context.read<LibraryBloc>().add(SetLibs(libs: mangaList));
      }

      if (!context.mounted) return;
      // Navigator.rep(context, '/home');
      Navigator.popAndPushNamed(context, '/home');
      // _navigationService.navigateTo('/home', {});
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
