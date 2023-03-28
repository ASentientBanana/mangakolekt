import 'package:flutter/material.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib_grid.dart';
import 'package:mangakolekt/widgets/lib_list.dart';

import '../widgets/lib_add.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Image> images = [];

  bool isPickingFile = false;
  bool showDialog = false;
  String selectedDir = '';

  // Widget bookBuilder(BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
  //   return Wrap(
  //       children: snapshot.hasData
  //           ? snapshot.data!.map((e) {
  //               return Column(
  //                 children: [e.image, Text(e.name)],
  //               );
  //             }).toList()
  //           : []);
  // }

  Future<void> pickDirHandler() async {
    setState(() {
      isPickingFile = true;
    });
    final dir = await pickDirectory();
    print("picked: $dir");
    if (dir == null) {
      closeDialogHandler();
      return;
    }
    setState(() {
      showDialog = true;
      selectedDir = dir;
    });
  }

  void closeDialogHandler() {
    setState(() {
      showDialog = false;
      isPickingFile = false;
      selectedDir = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Library you want to read',
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Stack(
          children: [
            Row(
              children: const [
                Flexible(
                  flex: 1,
                  child: LibList(),
                ),
                Flexible(
                  flex: 3,
                  child: LibGrid(),
                ),
              ],
            ),
            Positioned.fill(
              child: Visibility(
                visible: showDialog,
                child: Center(
                  child: AddToLibraryModal(
                      selectedDir: selectedDir,
                      confirmCallback: closeDialogHandler),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: isPickingFile ? null : pickDirHandler,
          child: const Icon(Icons.add)),
    );
  }
}
