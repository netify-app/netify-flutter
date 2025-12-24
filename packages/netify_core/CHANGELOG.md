# Changelog

## 3.0.3 - 2025-12-24

### Fixed

- Updated `screenshot` dependency from `^2.1.0` to `^3.0.0` for Flutter 3.35.0+ compatibility
- Updated `rxdart` dependency to `^0.28.0`
- Fixes `ViewConfiguration` API breaking changes in Flutter 3.35.0

## 3.0.2 - 2025-12-23

### Changed

- Restricted platform support to Android and iOS only
- Removed misleading platform badges for web and desktop
- Accurately reflects tested and supported platforms

## 3.0.1 - 2025-12-23

### Added

- Example app demonstrating package structure
- Improved pub.dev score with example requirement

## 3.0.0 - 2025-12-23

### 🎉 Major Release - Multi-Client Architecture

This release introduces a completely new architecture that separates core functionality from HTTP client-specific implementations.

#### Breaking Changes

- Core functionality extracted into standalone `netify_core` package
- No longer includes HTTP client implementations
- Must be used with an adapter package (`netify_dio`, `netify_http`, etc.)

#### New Features

- ✅ **Client-Agnostic Core** - No HTTP client dependencies
- ✅ **NetifyAdapter Base Class** - Foundation for all adapters
- ✅ **NetifyInterface** - Standardized interface for UI access
- ✅ **RxDart Integration** - Real-time streams with `BehaviorSubject`
- ✅ **Callbacks System** - Integration hooks for monitoring services
  - `NetifyCallbacks` class with `onRequest`, `onResponse`, `onError`, `onSlowRequest`
- ✅ **Smart Filters** - Control what gets captured
  - `NetifyFilters` class with status codes, slow requests, ignore patterns
- ✅ **Complete UI Components**
  - `NetifyPanel` - Main inspection panel
  - `LogDetailPage` - Detailed log viewer
  - `InsightsPage` - Analytics page
  - `NetifyBubble` - Floating bubble widget
  - All supporting widgets (badges, cards, viewers, etc.)
- ✅ **Repository Pattern** - Clean data management
  - `LogRepository` interface
  - `LogRepositoryImpl` with RxDart streams
- ✅ **Universal NetworkLog** - Works with any HTTP client

#### Architecture

The new architecture follows a modular design:

```
netify_core (this package)
    ↓
netify_dio, netify_http, netify_graphql, etc.
    ↓
Your App
```

#### Dependencies

- `flutter` - Flutter SDK
- `screenshot: ^2.1.0` - For share as image functionality
- `rxdart: ^0.27.0` - For real-time streams

**No HTTP client dependencies** ✅

#### Usage

This package is not meant to be used directly. Instead, use one of the adapter packages:

```dart
// For Dio
import 'package:netify_dio/netify_dio.dart';
await NetifyDio.init(dio: dio);

// For HTTP
import 'package:netify_http/netify_http.dart';
await NetifyHttp.init(client: client);
```

#### Benefits

1. **Zero Dependency Bloat** - Users only install the HTTP client they use
2. **Easy to Extend** - Add new HTTP clients by creating adapters
3. **Backward Compatible** - Adapters maintain similar API to v2.x
4. **Type-Safe** - Each adapter handles client-specific types
5. **Maintainable** - Core logic separated from client-specific code

#### Notes

- Compatible with Flutter 3.0.0+
- Dart SDK 3.0.0+
- Requires an adapter package to function
