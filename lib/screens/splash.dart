
import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/initializer.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
import 'package:mangakolekt/widgets/loadingDog.dart';
import 'package:mangakolekt/widgets/modals/permissionPrompt.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _navigationService = locator<NavigationService>();
  final libraryStore = locator<LibraryStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Center(
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
      await showPermissionDialog(context);
      await initAppStructure();
      final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();

      libraryStore.setLibrary(mangaList);

      if (!context.mounted) return;

      // _navigationService.errorDialog(error: "Some err message");
      _navigationService.pushAndPop('/home', {});
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      _navigationService.errorDialog(error: e.toString());
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
