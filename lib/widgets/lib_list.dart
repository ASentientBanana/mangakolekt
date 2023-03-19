import 'package:flutter/material.dart';
import 'package:mangakolekt/util/files.dart';

class LibList extends StatefulWidget {
  const LibList({super.key});

  @override
  State<LibList> createState() => _LibListState();
}

class _LibListState extends State<LibList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(30),
      child: FutureBuilder(
        builder: (context, snapshot) {
          final list = snapshot.data
              ?.map(
                (e) => Padding(
                  padding: EdgeInsets.all(10),
                  child: ElevatedButton(onPressed: () {}, child: Text(e)),
                ),
              )
              .toList();
          return Column(
            children: list ?? [],
          );
        },
        future: readAppDB(),
      ),
    );
  }
}
