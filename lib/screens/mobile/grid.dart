import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/library/grid.dart';

class MobileGreedScreen extends StatelessWidget {
  const MobileGreedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: colorScheme.surface,
      body: const LibGrid(),
    );
  }
}
