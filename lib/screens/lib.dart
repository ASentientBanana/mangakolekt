import 'package:flutter/material.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/Book.dart';
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
                child: Container(
                  color: Colors.orange,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            libBloc.libSink.add("Some string");
          }),
    );
  }
}
