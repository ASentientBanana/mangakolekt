import 'package:flutter/material.dart';
import 'package:mangakolekt/util/files.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // init function to create, load and read any data before opening home page
  Future<void> initApp(BuildContext context) async {
    //create log file
    await Future.delayed(const Duration(seconds: 1));
    //This is only since the compiler doesnt like async + context

    await createLogFile();

    createAppDB().then((value) {
      Navigator.pushNamed(context, '/home');
    });
  }

  @override
  void initState() {
    initApp(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
