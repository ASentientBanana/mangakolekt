abstract class BaseFFIService {
  Future<List<String>> ffiUnzipSingleBook(String _bookPath, String _targetPath);

  Future<List<String>> ffiUnzipCovers(
      List<String> files, String path, String out);
}

class UnsupportedNativePlatformService extends BaseFFIService {
  @override
  Future<List<String>> ffiUnzipCovers(
      List<String> files, String path, String out) async {
    // TODO: implement ffiUnzipCovers
    return [];
  }

  @override
  ffiUnzipSingleBook(String _bookPath, String _targetPath) async {
    return [];
  }
}
