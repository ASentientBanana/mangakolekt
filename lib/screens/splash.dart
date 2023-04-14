import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mangakolekt/util/files.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // init function to create, load and read any data before opening home page
  Future<void> init(BuildContext context) async {
    // Directory tempDir = await getTemporaryDirectory();

    // // var listener = tempDir.list(recursive: false, followLinks: false);
    // var tmp = Directory("${tempDir.path}/$tmpDirName");
    // var tmpBooks = Directory("${tempDir.path}/$tmpDirName/books");
    // var tmpBook = Directory("${tempDir.path}/$tmpDirName/book");

    // // Create base tmp dir
    // await tmp.create();
    // // create book dir
    // await tmpBook.create();
    // // create books dir ( dir for storing tmp book covers )
    // await tmpBooks.create();
    // create map app file
    //create log file
    await Future.delayed(const Duration(seconds: 1));
    //This is only since the compiler doesnt like async + context

    await createLogFile();

    createAppDB().then((value) {
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    init(context);
    return const Scaffold(
      body: Center(
        child: Text(
          "Loading data...",
          textScaleFactor: 11,
        ),
      ),
    );
  }
}
