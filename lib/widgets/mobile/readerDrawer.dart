import 'package:flutter/material.dart';
import 'package:mangakolekt/controllers/reader.dart';
import 'package:mangakolekt/locator.dart';
import 'package:mangakolekt/models/navigation.dart';
import 'package:mangakolekt/services/navigationService.dart';
import 'package:mangakolekt/util/files.dart';
import 'package:mangakolekt/widgets/reader/list_preview.dart';

class ReaderDrawerMobile extends StatelessWidget {
  ScrollController sc;
  ReaderController rc;
  void Function(int) onTap;
  ReaderDrawerMobile(
      {Key? key, required this.onTap, required this.sc, required this.rc})
      : super(key: key);
  final _navigationService = locator<NavigationService>();

  final List<NavigationItem> items = [];

  void handlePickFile() async {
    final file = await pickFile();

    if (file != null) {
      _navigationService.navigateTo('/reader', {"id": 0, "path": file});
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget? buildItem(BuildContext context, int index) {
      // return Text(items[index]);
    }

    Widget buildSeperator(BuildContext context, int index) {
      return SizedBox.shrink();
    }

    return Drawer(
      backgroundColor: colorScheme.primary,

      child:
          ListPreview(scrollController: sc, readerController: rc, onTap: onTap),
      // ),
    );
  }
}
