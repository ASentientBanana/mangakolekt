import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib/add.dart';
import 'package:mangakolekt/widgets/lib/grid.dart';
import 'package:mangakolekt/widgets/lib/list.dart';

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
  BookCover? selectedCover;

  Future<void> pickDirHandler() async {
    setState(() {
      isPickingFile = true;
    });
    final dir = await pickDirectory();
    if (dir == null) {
      closeDialogHandler();
      return;
    }
    setState(() {
      showDialog = true;
      selectedDir = dir;
    });
  }

  void selectManga(BookCover cover) {
    setState(() {
      selectedCover = cover;
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
    context.read<ReaderBloc>().add(LoadBook(bookView: BookView.init()));
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
