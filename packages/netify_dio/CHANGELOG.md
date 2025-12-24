# Changelog

## 3.0.3 - 2025-12-24

### Changed

- Updated dependency on `netify_core` to v3.0.3 for Flutter 3.35.0+ compatibility
- Ensures compatibility with latest Flutter SDK versions

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

### 🎉 Major Release - Multi-Client Architecture

This release introduces the new multi-client architecture, making Netify compatible with multiple HTTP clients without dependency bloat.

#### Breaking Changes

- Package renamed from `netify` to `netify_dio`
- Now depends on `netify_core` for shared functionality
- Import path changed: `import 'package:netify_dio/netify_dio.dart';`

#### New Features

- ✅ **Multi-Client Support** - Part of new modular architecture
- ✅ **NetifyInterface Implementation** - Full interface support
- ✅ **Export Functionality**
  - Export logs as JSON
  - Export logs as HAR (HTTP Archive) format
  - Generate cURL commands
- ✅ **Replay Requests** - Replay any captured request using Dio
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

#### Migration from v2.x

**Before (v2.x):**

```dart
import 'package:netify/netify.dart';
await Netify.init(dio: dio);
```

**After (v3.0.0):**

```dart
import 'package:netify_dio/netify_dio.dart';
await NetifyDio.init(dio: dio);
```

The API remains largely the same, just change the import and class name.

#### Dependencies

- `flutter` - Flutter SDK
- `dio: ^5.4.0` - Dio HTTP client
- `netify_core: ^3.0.0` - Core Netify functionality

#### Architecture

- Uses Dio interceptor pattern for automatic capture
- Delegates core functionality to `netify_core`
- Zero dependencies on other HTTP clients
- Clean separation of concerns

#### Notes

- This package requires `netify_core` v3.0.0 or higher
- Compatible with Dio 5.4.0+
- Flutter 3.0.0+
- Dart SDK 3.0.0+
