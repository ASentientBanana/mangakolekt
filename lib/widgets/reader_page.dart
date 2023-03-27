import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/bloc/library.dart';
import 'package:mangakolekt/models/book.dart';

class ReaderPage extends StatelessWidget {
  final PageEntry item;

  const ReaderPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width,
      child: Column(
        children: [item.image],
      ),
    );
  }
}
