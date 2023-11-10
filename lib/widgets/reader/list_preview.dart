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
      children: readerController.pages.asMap().entries.map(
        (e) {
          final isSelected = readerController
              .getCurrentPages()
              .any((element) => (e.value.index == element));

          return Padding(
              padding: EdgeInsets.only(
                  bottom: isSelected &&
                          e.value.index !=
                              readerController.getCurrentPages().last
                      ? 0
                      : 10),
              child: Column(
                children: [
                  Container(
                    color: isSelected
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.transparent,
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
                              padding: EdgeInsets.all(isSelected ? 3 : 0),
                              child: e.value.entry.image),
                        ),
                      ),
                    ),
                  ),
                  Text("${e.key + 1}"),
                ],
              ));
        },
      ).toList(),
    );
  }
}
