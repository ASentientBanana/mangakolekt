import 'dart:convert';

class FFICoverResult{
  final String name;
  final String bookPath;
  final String coverPath;
  const FFICoverResult({ required this.name, required this.bookPath, required this.coverPath});
}

class FFICoverInput{
  final List<String> files;
  const FFICoverInput({required this.files});
  @override
  String toString() {
    final jsonInput =  json.encode(files);
    return '{ files : $jsonInput }';
  }
}
