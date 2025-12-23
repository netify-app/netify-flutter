# Changelog

## 3.0.2 - 2025-12-23

### Changed

- Restricted platform support to Android and iOS only
- Removed misleading platform badges for web and desktop
- Accurately reflects tested and supported platforms

## 3.0.1 - 2025-12-23

### Added

- Complete example app with JSONPlaceholder API integration
- Demonstrates GET, POST, PUT, DELETE requests
- Shows error handling and callbacks usage
- Improved pub.dev score with example requirement

## 3.0.0 - 2025-12-23

### 🎉 Initial Release

**Multi-Client Architecture Support**

This is the first release of `netify_http` as part of the Netify v3.0.0 multi-client architecture.

#### Features

- ✅ **HTTP Client Wrapper** - Extends `http.BaseClient` for automatic capture
- ✅ **Request/Response Capture** - Automatic logging of all HTTP requests
- ✅ **Full HTTP Method Support** - GET, POST, PUT, PATCH, DELETE
- ✅ **Export Functionality**
  - Export logs as JSON
  - Export logs as HAR (HTTP Archive) format
  - Generate cURL commands
- ✅ **Replay Requests** - Replay any captured request
- ✅ **Callbacks System** - Integration hooks for monitoring services
  - `onRequest` - Called when request starts
  - `onResponse` - Called when response received
  - `onError` - Called on request error
  - `onSlowRequest` - Called for slow requests
- ✅ **Smart Filters** - Control what gets captured
  - Filter by status codes
  - Filter by request duration
  - Ignore specific paths
  - Ignore specific hosts
- ✅ **Floating Bubble UI** - Quick access overlay
- ✅ **Favorites Management** - Mark important requests
- ✅ **Search Functionality** - Search through captured logs
- ✅ **Share Logs** - Export and share network logs

#### Dependencies

- `flutter` - Flutter SDK
- `http: ^1.1.0` - HTTP client package
- `netify_core: ^3.0.0` - Core Netify functionality

#### Usage

```dart
import 'package:http/http.dart' as http;
import 'package:netify_http/netify_http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = http.Client();
  await NetifyHttp.init(client: client);

  runApp(MyApp());
}

// Use the wrapped client
final response = await NetifyHttp.client.get(
  Uri.parse('https://api.example.com/users'),
);
```

#### Architecture

- Uses client wrapper pattern (extends `http.BaseClient`)
- Works with any code using the `http` package
- Zero dependencies on other HTTP clients
- Clean separation from core functionality

#### Notes

- This package requires `netify_core` v3.0.0 or higher
- Compatible with Flutter 3.0.0+
- Dart SDK 3.0.0+
