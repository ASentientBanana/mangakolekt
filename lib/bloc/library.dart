import 'package:flutter_bloc/flutter_bloc.dart';

class LibBloc extends Cubit<String> {
  LibBloc() : super('');

  void setPath(String path) {
    print(path);
    return emit(path);
  }

  // void decrement() => emit(state - 1);
}
