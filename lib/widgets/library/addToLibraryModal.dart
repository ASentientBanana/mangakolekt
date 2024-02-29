import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/services/ffiService.dart';
import 'package:mangakolekt/util/database/database_helpers.dart';
import 'package:mangakolekt/util/files.dart';
import 'dart:isolate';

class AddToLibraryModal extends StatefulWidget {
  final String selectedDir;

  const AddToLibraryModal({super.key, required this.selectedDir});

  @override
  AddToLibraryModalState createState() => AddToLibraryModalState();
}

void getNumberOfPages(SendPort send) async {}

class AddToLibraryModalState extends State<AddToLibraryModal> {
  final TextEditingController textEditingController = TextEditingController();

  double numberOfFiles = 0;
  double maxNumberOfFiles = 1;
  bool isSubmitDisabled = false;

  void incrementProgress() {
    setState(() {
      numberOfFiles++;
    });
  }

  void getMaxNumber() async {
    final numberOfFiles = await getNumberOfFiles(widget.selectedDir);
    setState(() {
      maxNumberOfFiles = numberOfFiles.toDouble();
    });
  }

  @override
  void initState() {
    getMaxNumber();
    textEditingController.text = widget.selectedDir.split('/').last;
    super.initState();
  }

  Future<List<String>?> startIsolate() async {
    try {
      // final res = await compute(
      //     (message) => ArchiveController.unpackCovers(message, null),
      //     widget.selectedDir);
      final res =
          await ArchiveController.unpackCovers(widget.selectedDir, null);
      return res;
    } catch (e) {
      print(e);
      if (!context.mounted) {
        return [];
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
      );
      return [];
    }
  }

  void handleSubmit(BuildContext context) async {
    if (!context.mounted) {
      return;
    }

    final selectedDir = widget.selectedDir;
    setState(() {
      isSubmitDisabled = true;
    });

    // await FFIService.checkLibDir(widget.selectedDir);

    //Format is name;path;bookPath
    final bookCoverMapStringList = await startIsolate();

    print(bookCoverMapStringList);

    if (bookCoverMapStringList == null) {
      return;
    }
    // Add manga to Manga table in db
    final mangaList = await DatabaseMangaHelpers.addManga(
        path: selectedDir, name: textEditingController.text, returnManga: true);

    if (mangaList == null) {
      return;
    }

    final id = mangaList
        .firstWhere((element) => element.name == textEditingController.text)
        .id;
    await DatabaseMangaHelpers.addMangaMapping(bookCoverMapStringList, id);

    if (mangaList.isNotEmpty && context.mounted) {
      context.read<LibraryBloc>().add(SetLibs(libs: mangaList));
    }
    // });

    setState(() {
      isSubmitDisabled = false;
    });
    context.read<LibraryBloc>().add(CloseAddToLibModal());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 240,
      width: 500,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 1, style: BorderStyle.solid),
        color: colorScheme.primary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Enter a name for the lib located at:',
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              widget.selectedDir,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 18,
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
                      shape: BeveledRectangleBorder(),
                      // side: BorderSide(color: colorScheme.secondary)
                    ),
                    onPressed:
                        isSubmitDisabled ? null : () => handleSubmit(context),
                    child: isSubmitDisabled
                        ? const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : const Text(
                            "Confirm",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
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
                    onPressed: !isSubmitDisabled
                        ? () {
                            context
                                .read<LibraryBloc>()
                                .add(CloseAddToLibModal());
                          }
                        : null,
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
