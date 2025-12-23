/// Platform-specific functionality interface
abstract class NetifyPlatform {
  /// Get the application name
  Future<String> getAppName();

  /// Get the temporary directory path
  Future<String> getTempDirectory();

  /// Get the application documents directory path
  Future<String> getDocumentsDirectory();

  /// Share a file with other apps
  Future<void> shareFile(String path, String mimeType);

  /// Share text with other apps
  Future<void> shareText(String text);
}
