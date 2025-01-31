import 'package:flutter/material.dart';
import 'package:mangakolekt/widgets/loadingDog.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: const Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: LoadingDog(),
        ),
      ),
    );
  }
}
