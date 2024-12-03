import 'package:flutter/material.dart';

class BookmarkMangaButton extends StatelessWidget {
  final String name;
  final bool selected;
  final int index;
  final void Function(int) selectBookmarkCb;
  const BookmarkMangaButton(
      {Key? key,
      required this.name,
      required this.index,
      required this.selected,
      required this.selectBookmarkCb})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: const BoxDecoration(borderRadius: BorderRadius.zero
          // border: Border.all(color: colorScheme.tertiary, width: 2),
          ),
      child: ElevatedButton(
        style: const ButtonStyle().copyWith(
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: WidgetStatePropertyAll(
              selected ? colorScheme.tertiary : colorScheme.onPrimary),
        ),
        onPressed: () => selectBookmarkCb(index),
        child: Center(
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
