import 'package:flutter/material.dart';

class MangaReader extends StatefulWidget {
  MangaReader({Key? key}) : super(key: key);

  @override
  _MangaReaderState createState() => _MangaReaderState();
}

class _MangaReaderState extends State<MangaReader> {
  //TODO: Add init state to scan for open manga
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          return Center(
            child: Column(
              children: [],
            ),
          );
        },
        //TODO: complete the future
        // future: () async {
        //   final args = ModalRoute.of(context)!.settings.arguments as String;
        //   await Future.delayed(100);

        //   return Object();
        // },
      ),
    );
  }
}
