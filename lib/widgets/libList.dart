import 'package:flutter/material.dart';

class LibList extends StatelessWidget {
  const LibList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      padding: EdgeInsets.all(30),
      child: ListView(children: [
        Text("Test"),
        Text("Test"),
        Text("Test"),
        Text("Test"),
        Text("Test"),
      ]),
    );
  }
}
