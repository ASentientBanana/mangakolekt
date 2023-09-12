import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';
import 'package:mangakolekt/controllers/reader.dart';

class ListPreview extends StatelessWidget {
  final ScrollController scoreController;
  final void Function(int index)? onTap;
  final ReaderController readerController;

  const ListPreview(
      {super.key,
      required this.scoreController,
      required this.readerController,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scoreController,
      children: readerController.pages
          .asMap()
          .entries
          .map(
            (e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: FractionallySizedBox(
                    heightFactor: 1,
                    // height: 100,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          if (onTap != null) {
                            onTap!(e.value.index);
                          }
                        },
                        child: Container(
                            color: Colors.red,
                            padding:
                                EdgeInsets.all(e.value.index == e.key ? 0 : 10),
                            child: e.value.entry.image),
                      ),
                    ),
                  ),
                )),
          )
          .toList(),
    );
  }
}
