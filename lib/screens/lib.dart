import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/Book.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/libGrid.dart';
import 'package:mangakolekt/widgets/libList.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Image> images = [];

  final libBloc = LibraryBloc();

  Widget bookBuilder(BuildContext context, AsyncSnapshot<List<Book>> snapshot) {
    return Wrap(
        children: snapshot.hasData
            ? snapshot.data!.map((e) {
                return Column(
                  children: [e.image, Text(e.name)],
                );
              }).toList()
            : []);
  }

  Future<void> pickDirHandler() async {
    final dir = await pickDirectory();
    if (dir == null) return;
    await createLibFolder(dir);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    libBloc.cleanup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Library you want to read')),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
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
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            pickDirHandler();
          }),
    );
  }
}
