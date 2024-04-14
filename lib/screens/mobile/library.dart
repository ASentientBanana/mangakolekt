import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/store/library.dart';
import 'package:mangakolekt/widgets/homeLogo.dart';
import 'package:mangakolekt/widgets/library/listItem.dart';
import 'package:mangakolekt/widgets/mobile/libraryDrawer.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePageMobile extends StatefulWidget {
  const MyHomePageMobile({super.key});
  @override
  State<MyHomePageMobile> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePageMobile> {
  BookCover? selectedCover;
  final textEditingController = TextEditingController();

  final _navigationService = locator<NavigationService>();
  final libraryStore = locator<LibraryStore>();

  bool disableAdd = false;

  void selectManga(BookCover cover) {
    setState(() {
      selectedCover = cover;
    });
  }

  Future<String?> pickDirHandler(BuildContext context) async {
    final dir = await FilePicker.platform.getDirectoryPath();
    if (dir == null || !context.mounted) {
      return null;
    }
    // showCreateLibDialog(context, dir);
    // final d = Directory(dir);
    // ScaffoldMessenger.of(context)
    //     .showSnackBar(SnackBar(content: Text(d.listSync().toString())));
    //  dir

    return dir;
  }

  // await pickDirHandler(context);

  Future<void> handleAdd(BuildContext context) async {
    if (!(await Permission.manageExternalStorage.isGranted)) {
      final result = await Permission.manageExternalStorage.request();
      if (result.isDenied || result.isPermanentlyDenied) {
        return;
      }
    }

    if (!context.mounted) {
      return;
    }
    final dir = await pickDirHandler(context);
    if (dir == null) {
      return;
    }
    _navigationService.navigateTo("/addLibrary", {"path": dir});
    // showDialog(
    //   barrierDismissible: false,
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       backgroundColor: Theme.of(context).colorScheme.primary,
    //       contentPadding: const EdgeInsets.all(0),
    //       content: const Padding(
    //           padding: EdgeInsets.symmetric(horizontal: 10),
    //           child: Text("The app is missing permisions permission")),
    //       actions: [
    //         TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: const Text("Close")),
    //         TextButton(
    //             onPressed: () {
    //               Permission.manageExternalStorage.request();
    //             },
    //             child: Text("ok")),
    //       ],
    //     );
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      drawer: SafeArea(child: LibraryDrawer()),
      appBar: AppBar(actions: [
        SizedBox(
          width: 300,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Stack(
              children: [
                Container(
                  height: 32,
                  padding: const EdgeInsets.only(right: 15),
                  child: Material(
                      child: TextField(
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      hintText: "Search books",
                      hintStyle: TextStyle(color: colorScheme.onPrimary),
                      fillColor: colorScheme.background,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide:
                            BorderSide(width: 1, color: colorScheme.onPrimary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide:
                            BorderSide(width: 1, color: colorScheme.onPrimary),
                      ),
                    ),
                    onChanged: (s) {
                      libraryStore.search(s);
                    },
                    controller: textEditingController,
                  )),
                ),
                Positioned(
                  top: 4,
                  right: 25,
                  child: Icon(
                    Icons.search_sharp,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ],
            )
          ]),
        ),
      ]),
      body: SafeArea(
        // color: Colors.red,
        child: Observer(builder: (_) {
          if (libraryStore.library.isEmpty) {
            return HomeLogo();
          }
          return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) => Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: LibListItem(
                        item: libraryStore.library[index], index: index),
                  ),
              separatorBuilder: (_, index) => const SizedBox(
                    height: 10,
                  ),
              itemCount: libraryStore.library.length);
        }),
      ),
      // child: LibList(),

      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
            side: const BorderSide(
                width: 3, color: Color.fromARGB(255, 238, 245, 238)),
            borderRadius: BorderRadius.circular(100)),
        backgroundColor: colorScheme.background,
        onPressed: () => handleAdd(context),
        child: const Icon(size: 42, Icons.add),
      ),
    );
    // return
  }
}
