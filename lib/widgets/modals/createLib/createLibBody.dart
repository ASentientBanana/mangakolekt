import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/ffi.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/services/database/databaseHelpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/util/util.dart';

class CreateLibBody extends StatefulWidget {
  final String selectedDir;

  const CreateLibBody({super.key, required this.selectedDir});

  @override
  CreateLibBodyState createState() => CreateLibBodyState();
}

class CreateLibBodyState extends State<CreateLibBody> {
  final TextEditingController textEditingController = TextEditingController();

  int numberOfFiles = 0;
  double maxNumberOfFiles = 1;
  int initialNuberOfFiles = 0;
  bool isSubmitDisabled = false;

  final _navigationService = locator<NavigationService>();
  final libraryStore = locator<LibraryStore>();

  @override
  void initState() {
    textEditingController.text = widget.selectedDir.split('/').last;
    super.initState();
  }

  Future<List<FFICoverOutputResult>?> startIsolate() async {
    try {
      // compute
      final out = await getGlobalCoversDir();

      final res = await compute(
          (message) => ArchiveController.unpackCovers(message[0], message[1]),
          [widget.selectedDir, out]);
      // final res = await ArchiveController.unpackCovers(widget.selectedDir, out);
      return res;
    } catch (e) {
      if (!context.mounted) {
        return [];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
      );
      return [];
    }
  }

  void handleSubmit() async {
    setState(() {
      isSubmitDisabled = true;
    });

    final coversPathList = await startIsolate();
    if (coversPathList == null || coversPathList.isEmpty) {
      return;
    }

    final id = await DatabaseMangaHelpers.addLibrary(
        libraryPath: widget.selectedDir,
        name: textEditingController.text,
        books: coversPathList);
    final mangaList = await DatabaseMangaHelpers.getAllBooksFromLibrary();
    final index = mangaList.indexWhere((element) => element.id == id);
    if (mangaList.isNotEmpty) {
      libraryStore.setLibrary(mangaList);
      libraryStore.selectCover(index);
    }
    setState(() {
      isSubmitDisabled = false;
    });
    closeModal();
  }

  void closeModal() {
    _navigationService.goBack();
  }
  // TODO: Maybe implement progress indicator
  // Future<void> checkProgress({bool initial = false}) async {
  //   final out = await getGlobalCoversDir();
  //   final dir = Directory(out);
  //   const duration = Duration(seconds: 1);

  //   while (isSubmitDisabled) {
  //     final itemCount = await (dir.list()).length;

  //     await Future.delayed(duration);
  //     if (initial) {
  //       setState(() {
  //         initialNuberOfFiles = itemCount;
  //       });
  //       break;
  //     }
  //     setState(() {
  //       numberOfFiles = itemCount;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      // width: 500,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 1, style: BorderStyle.solid),
        color: colorScheme.primary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter a name for the lib located at:',
            style: TextStyle(
              fontSize: isMobile() ? 18 : 23,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.selectedDir,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isMobile() ? 12 : 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 360,
            padding: const EdgeInsets.only(top: 10),
            child: TextFormField(
              controller: textEditingController,
              showCursor: true,
              cursorColor: colorScheme.tertiary,
              decoration: InputDecoration(
                  hintText: "Enter a label for the lib",
                  hintStyle: const TextStyle(color: Colors.white60),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: 4, color: colorScheme.tertiary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide:
                        BorderSide(width: 4, color: colorScheme.tertiary),
                  )),
            ),
          ),
          SizedBox(
            width: 360,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: colorScheme.tertiary,
                      shape: const BeveledRectangleBorder(),
                      // side: BorderSide(color: colorScheme.secondary)
                    ),
                    onPressed: isSubmitDisabled ? null : handleSubmit,
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 30),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0, backgroundColor: Colors.white,
                      shape: const BeveledRectangleBorder(),
                      // side: BorderSide(color: colorScheme.secondary)
                    ),
                    onPressed: !isSubmitDisabled ? closeModal : null,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
