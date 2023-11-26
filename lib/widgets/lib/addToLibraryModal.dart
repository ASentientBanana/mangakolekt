import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/controllers/archive.dart';
import 'package:mangakolekt/models/book.dart';
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
    final cb = await ArchiveController.unpackCovers(widget.selectedDir);
    if (cb == null) {
      return null;
    }
    final res = await compute(cb, widget.selectedDir);
    return res;
  }

  void handleSubmit(BuildContext context) async {
    final selectedDir = widget.selectedDir;
    setState(() {
      isSubmitDisabled = true;
    });

    if (isSubmitDisabled) {
      //Format is name;path;bookPath
      final bookCoverMapStringList = await startIsolate();

      if (bookCoverMapStringList == null) {
        return;
      }
      // Add manga to Manga table in db
      final mangaList = await DatabaseMangaHelpers.addManga(
          path: selectedDir,
          name: textEditingController.text,
          returnManga: true);

      if (mangaList == null) {
        return;
      }

      final id = mangaList
          .firstWhere((element) => element.name == textEditingController.text)
          .id;
      await DatabaseMangaHelpers.addMangaMapping(bookCoverMapStringList, id);

      if (mangaList.isNotEmpty) {
        context.read<LibraryBloc>().add(SetLibs(libs: mangaList));
      }
      // });
    }

    setState(() {
      isSubmitDisabled = false;
    });
    //TODO: CLOSE MODAL
    context.read<LibraryBloc>().add(CloseAddToLibModal());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(width: 1, style: BorderStyle.solid),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Enter a name for the lib located at:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Text(widget.selectedDir),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Manga name',
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
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
                      : const Text('Add'),
                )),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSubmitDisabled
                        ? null
                        : () {
                            context
                                .read<LibraryBloc>()
                                .add(CloseAddToLibModal());
                          },
                    child: const Text('Cancel'),
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
