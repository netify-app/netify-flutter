import 'package:flutter/services.dart';
import 'platform_interface.dart';

/// Implementation of NetifyPlatform using method channels
class NetifyPlatformChannels implements NetifyPlatform {
  static const MethodChannel _channel = MethodChannel('com.netify/platform');

  @override
  Future<String> getAppName() async {
    try {
      final String? appName = await _channel.invokeMethod('getAppName');
      return appName ?? 'Netify';
    } catch (e) {
      return 'Netify';
    }
  }

  @override
  Future<String> getTempDirectory() async {
    try {
      final String? path = await _channel.invokeMethod('getTempDirectory');
      return path ?? '';
    } catch (e) {
      return '';
    }
  }

  @override
  Future<String> getDocumentsDirectory() async {
    try {
      final String? path = await _channel.invokeMethod('getDocumentsDirectory');
      return path ?? '';
    } catch (e) {
      return '';
    }
  }

  @override
  Future<void> shareFile(String path, String mimeType) async {
    try {
      await _channel.invokeMethod('shareFile', {
        'path': path,
        'mimeType': mimeType,
      });
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Future<void> shareText(String text) async {
    try {
      await _channel.invokeMethod('shareText', {'text': text});
    } catch (e) {
      // Silently fail
    }
  }
}
