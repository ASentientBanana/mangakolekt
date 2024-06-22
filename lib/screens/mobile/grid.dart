import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/library/grid.dart';

class MobileGreedScreen extends StatelessWidget {
  const MobileGreedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: colorScheme.background,
      body: const LibGrid(),
    );
  }
}
