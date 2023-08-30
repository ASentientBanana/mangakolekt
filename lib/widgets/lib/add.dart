import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
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

Future<void> _submitIsolateCallback(String target) async {
  await createLibFolder(target);
}

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

  Future startIsolate() async {
    await compute(_submitIsolateCallback, widget.selectedDir);
  }

  // Todo: paralelize this
  void handleSubmit(BuildContext context) async {
    final selectedDir = widget.selectedDir;
    setState(() {
      isSubmitDisabled = true;
    });

    if (isSubmitDisabled) {
      await startIsolate();
      await addToAppDB(textEditingController.text, selectedDir).then((libList) {
        // Fluter doesn't like using context and async/await
        context.read<LibraryBloc>().add(SetLibs(libs: libList));
      });
    }

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
              hintText: 'Enter text here',
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
