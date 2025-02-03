abstract class BaseFFIService {
  Future<List<String>> ffiUnzipSingleBook(String bookPath, String targetPath);

  Future<List<FFICoverOutputResult>> ffiUnzipCovers(
      List<String> files, String path, String out);
}

class UnsupportedNativePlatformService extends BaseFFIService {
  @override
  Future<List<FFICoverOutputResult>> ffiUnzipCovers(
      List<String> files, String path, String out) async {
    // TODO: implement ffiUnzipCovers
    return [];
  }

  @override
  ffiUnzipSingleBook(String bookPath, String targetPath) async {
    return [];
  }
}

class FFICoverOutputResult{
 final String archiveName;
 final String destinationPath;
 final String  directoryFile;
  FFICoverOutputResult({required this.archiveName, required this.directoryFile, required this.destinationPath});
 static FFICoverOutputResult? fromMap(Map<String,dynamic> map){
 const fields = [
   "archiveName",
   "destinationPath",
   "directoryFile"
 ];
 bool isValid = true;
 for (var element in fields) {
   if(map[element] == null){
     isValid = false;
   }
 }

  if(!isValid){
    return null;
  }
  return FFICoverOutputResult(archiveName: map["archiveName"]!, directoryFile: map["directoryFile"]!, destinationPath: map["destinationPath"]!);
 }
}