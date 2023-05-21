import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';
import 'dart:isolate';

class AddToLibraryModal extends StatefulWidget {
  final void Function()? confirmCallback;
  final String selectedDir;

  const AddToLibraryModal(
      {super.key, this.confirmCallback, required this.selectedDir});

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

  void handleSubmit() async {
    setState(() {
      isSubmitDisabled = true;
    });
    final sw = Stopwatch()..start();

    await createLibFolder(widget.selectedDir, cb: incrementProgress);
    String enteredText = textEditingController.text;
    await addToAppDB(enteredText, widget.selectedDir).then((libList) {
      // Fluter doesn't like using context and async/await
      context.read<LibraryBloc>().add(SetLibs(libs: libList));
    });

    sw.stop();
    print(sw.elapsed);
    setState(() {
      isSubmitDisabled = false;
    });
    widget.confirmCallback!();
  }

  void handleCancel() {
    if (widget.confirmCallback != null) {
      widget.confirmCallback!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: Theme.of(context).colorScheme.tertiary,
            width: 1,
            style: BorderStyle.solid),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Enter a name for the lib located at: ${widget.selectedDir}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: textEditingController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter text here',
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: isSubmitDisabled ? null : handleSubmit,
                  child: isSubmitDisabled
                      ? const CircularProgressIndicator()
                      : const Text('Add'),
                )),
                const Padding(
                  padding: EdgeInsets.all(20),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isSubmitDisabled ? null : handleCancel,
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
