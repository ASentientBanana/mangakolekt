import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/app.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/bloc/reader/reader_bloc.dart';
import 'package:mangakolekt/locator.dart';

void main() {
  Paint.enableDithering = true;
  WidgetsFlutterBinding.ensureInitialized();
  setupServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LibraryBloc>(
            create: (BuildContext context) => LibraryBloc()),
        BlocProvider<ReaderBloc>(
            create: (BuildContext context) => ReaderBloc()),
      ],
      child: const AppWidget(),
    );
  }
}
