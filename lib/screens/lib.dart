import 'package:flutter/material.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/services/navigation_service.dart';
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
  String selectedFile = '';
  BookCover? selectedCover;

  final _navigationService = locator<NavigationService>();

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

  Future<void> pickFileHandler() async {
    final file = await pickFile();
    if (file == null) {
      closeDialogHandler();
      return;
    }
    _navigationService.navigateTo('/reader', {"id": 0, "path": file});
    // Navigator.pushNamed(context, '/reader',arguments: {"page":9999,});
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
    // double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Library you want to read',
        ),
        actions: [
          ElevatedButton(
            // style: ButtonStyle(
            //   backgroundColor: MaterialStateProperty.all(
            //       Theme.of(context).colorScheme.secondary),
            // ),
            onPressed: pickFileHandler,
            child: const SizedBox(
              width: 100,
              child: Icon(Icons.settings),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(4),
        color: Theme.of(context).colorScheme.background,
        child: Stack(
          children: [
            const Row(
              children: [LibList(), Expanded(child: LibGrid())],
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
