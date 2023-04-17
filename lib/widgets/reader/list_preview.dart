import 'package:flutter/material.dart';
import 'package:mangakolekt/models/book.dart';

class ListPreview extends StatelessWidget {
  final List<BookPage> pages;
  final ScrollController scoreController;
  final List<BookPage> currentPages;
  final void Function()? onTap;

  const ListPreview(
      {super.key,
      required this.pages,
      required this.scoreController,
      required this.currentPages,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: scoreController,
      children: pages
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
                        onTap: onTap,
                        child: Container(
                            decoration: BoxDecoration(
                                border: currentPages.any(
                                        (element) => element.index == e.index)
                                    ? Border.all(
                                        color: Colors.red,
                                        width: 5,
                                        style: BorderStyle.solid)
                                    : null),
                            child: e.entry.image),
                      ),
                    ),
                  ),
                )),
          )
          .toList(),
    );
  }
}
