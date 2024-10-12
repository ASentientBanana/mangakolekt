import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/loadingDog.dart';
import 'package:path/path.dart' as path;

class CreateLibraryMobile extends StatefulWidget {
  final String path;

  const CreateLibraryMobile({Key? key, required this.path}) : super(key: key);

  @override
  State<CreateLibraryMobile> createState() => _CreateLibraryMobileState();
}

class _CreateLibraryMobileState extends State<CreateLibraryMobile> {
  final textController = TextEditingController();
  bool isLoadingCovers = false;

  final libraryStore = locator<LibraryStore>();

  final _navigationService = locator<NavigationService>();

  final double buttonHorizontalMargins = 20;

  void handleCancel() {
    _navigationService.goBack();
  }

  @override
  void initState() {
    super.initState();
    textController.text = path.basenameWithoutExtension(widget.path);
  }

  void handleConfirm() async {
    final out = await getGlobalCoversDir();
    setState(() {
      isLoadingCovers = true;
    });
    try {
      final res = await compute((message) {
        final path = message[0];
        final out = message[1];
        return ArchiveController.unpackCovers(path, out);
      }, [widget.path, out]);

      if (res == null || res.isEmpty) {
        return;
      }
      await DatabaseMangaHelpers.addLibrary(
          libraryPath: widget.path, name: textController.text, books: res);
      final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();
      if (mangaList.isNotEmpty) {
        libraryStore.setLibrary(mangaList);
      }
      _navigationService.pushAndPop('/home', null);
    } catch (e) {
      isLoadingCovers = false;
    } finally {
      setState(() {
        isLoadingCovers = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (isLoadingCovers) {
      return Scaffold(
        backgroundColor: colorScheme.background,
        body: Center(
          child: LoadingDog(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Enter a name for the lib located at:'),
          Text(path.basenameWithoutExtension(widget.path)),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 50),
            child: TextFormField(
              controller: textController,
              showCursor: true,
              cursorColor: colorScheme.tertiary,
              decoration: InputDecoration(
                hintText: "Enter a label for the lib",
                hintStyle: const TextStyle(color: Colors.white60),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide:
                      BorderSide(width: 2, color: colorScheme.tertiary),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: buttonHorizontalMargins),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: colorScheme.tertiary,
                  shape: const BeveledRectangleBorder(),
                  // side: BorderSide(color: colorScheme.secondary),
                ),
              onPressed: () => handleConfirm(),
              child: const Text(
                "Add",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: buttonHorizontalMargins),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  shape: const BeveledRectangleBorder(),
                  side: const BorderSide(color: Colors.white),
              ),
              onPressed: handleCancel,
              child: const Text(
                "Cancel",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
