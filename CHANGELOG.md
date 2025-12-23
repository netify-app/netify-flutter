## 2.1.0

### ✨ New Features - Callbacks & Filters

**Integrate Netify with your monitoring stack!**

### Added

- 🔌 **Callbacks System** - Integrate with Sentry, Firebase, or custom webhooks
  - `onRequest` - Called when a request is sent
  - `onResponse` - Called when a response is received
  - `onError` - Called when a request fails
  - `onSlowRequest` - Called when request exceeds duration threshold
- 🎯 **Smart Filters** - Control what gets captured
  - `captureStatusCodes` - Only capture specific HTTP status codes
  - `captureSlowRequests` - Only capture requests slower than threshold
  - `ignorePaths` - Ignore specific URL paths
  - `ignoreHosts` - Ignore specific host domains
- 📦 **Example Integrations** - Ready-to-use integration helpers
  - Sentry integration example
  - Firebase Performance integration example
  - Custom webhook integration example

### Changed

- Updated `NetifyConfig` to support `callbacks` and `filters` parameters
- Updated `NetifyInterceptor` to trigger callbacks at appropriate lifecycle events
- Added `removeLog` method to `LogRepository` for filter-based log removal

### Example

```dart
await Netify.init(
  dio: dio,
  config: NetifyConfig(
    callbacks: NetifyCallbacks(
      onError: (log) {
        Sentry.captureException(
          Exception('Network request failed: ${log.url}'),
        );
      },
    ),
    filters: NetifyFilters(
      captureStatusCodes: [400, 401, 403, 404, 500],
      captureSlowRequests: Duration(seconds: 3),
      ignorePaths: ['/health', '/metrics'],
    ),
  ),
);
```

## 2.0.0

### 🎉 Major Release - Native Implementation

**Package is now ~380KB lighter!**

### Breaking Changes

- Replaced `share_plus`, `path_provider`, and `package_info_plus` with native Android/iOS code
- These dependencies are no longer required
- All functionality remains the same, just lighter and faster

### Added

- Native Android implementation using Kotlin
- Native iOS implementation using Swift
- Platform channel for cross-platform communication
- Automatic floating bubble overlay - no wrapper needed!
- Added `Netify.navigatorKey` for automatic bubble display
- Added `enable` parameter to `Netify.init()` for easier control

### Changed

- Moved `showOnlyInDebug` from `NetifyConfig` to `enable` parameter in `init()`
- Removed `NetifyWrapper` - no longer needed
- Reduced package size by ~380KB (~38% reduction)

### Removed

- ❌ `share_plus` dependency
- ❌ `path_provider` dependency
- ❌ `package_info_plus` dependency

### Migration Guide

No code changes needed! Just update to 2.0.0 and enjoy the lighter package.

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = Dio();
  await Netify.init(dio: dio, enable: kDebugMode);
  runApp(const MyApp());
}

MaterialApp(
  navigatorKey: Netify.navigatorKey, // ← Required for bubble
  home: HomePage(),
)
```

## 1.0.4

### Added

- Automatic floating bubble overlay - no wrapper needed!
- Added `Netify.navigatorKey` for automatic bubble display
- Added `enable` parameter to `Netify.init()` for easier control
- Bubble appears automatically after `Netify.init()`

### Changed

- Moved `showOnlyInDebug` from `NetifyConfig` to `enable` parameter in `init()`
- Removed `NetifyWrapper` - no longer needed

## 1.0.3

### Fixed

- Fixed deprecated Share API usage warnings
- Replaced Share.share() and Share.shareXFiles() with SharePlus.instance.share()
- Used correct ShareParams constructor with proper parameter names

### Updated

- Removed APK impact size from README Lightweight feature description

## 1.0.2

### Fixed

- Fixed flutter_lints SDK compatibility issue
- Fixed code formatting issues for pub.dev scoring

### Updated

- Updated dependencies to latest versions:
  - dio: ^5.9.0
  - share_plus: ^12.0.1
  - package_info_plus: ^9.0.0
- Added explicit Android/iOS platform support
- Added dartdoc comments to public API (20%+ coverage

## 1.0.1

### Fixed

- Fixed README screenshots not displaying on pub.dev (using absolute URLs))

## 1.0.0

### Features

- 📡 Network inspection via Dio interceptor
- 🫧 Draggable floating bubble with request count badge
- 🌙 Dark mode support with theme toggle
- 📁 Request grouping by domain
- ⭐ Favorites/bookmarks for important requests
- 📸 Share request details as image
- 🔍 Search and filter by status, method, URL
- 📤 Export as JSON or HAR format
- 🔄 cURL generation for any request
- 🔁 Replay requests
- 📊 Detailed metrics (time, size, duration)
- 🪶 Lightweight

### Architecture

- Clean architecture implementation
- Zero footprint in release builds
- In-memory only storage (no disk persistence)
