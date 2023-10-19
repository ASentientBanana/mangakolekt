import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mangakolekt/app.dart';
import 'package:mangakolekt/bloc/library/library_bloc.dart';
import 'package:mangakolekt/bloc/theme/theme_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        BlocProvider<ThemeBloc>(create: (BuildContext context) => ThemeBloc()),
      ],
      child: const Focus(
        canRequestFocus: false,
        child: AppWidget(),
      ),
    );
  }
}
