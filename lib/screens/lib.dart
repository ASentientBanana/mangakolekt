import 'package:flutter/material.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/lib_grid.dart';
import 'package:mangakolekt/widgets/lib_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Image> images = [];

  bool isPickingFile = false;

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
    print("PICKER");
    setState(() {
      isPickingFile = true;
    });
    final dir = await pickDirectory();
    if (dir == null) return;
    await createLibFolder(dir);
    await addToAppDB(dir);
    setState(() {
      isPickingFile = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Library you want to read')),
      body: Container(
        padding: const EdgeInsets.all(4),
        child: Row(
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
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: isPickingFile ? null : pickDirHandler),
    );
  }
}
