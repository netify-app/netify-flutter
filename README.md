# 🔍 Netify

A lightweight, debug-only network inspector for Flutter apps using Dio HTTP client. Features a modern UI with draggable floating bubble, dark mode, and share as image. Built with clean architecture principles and zero impact on release builds.

[![pub package](https://img.shields.io/pub/v/netify.svg)](https://pub.dev/packages/netify)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Features

- 📡 **Network Inspection** - Capture and inspect all HTTP requests/responses via Dio interceptor
- 🫧 **Floating Bubble** - Draggable floating bubble with request count badge
- 🌙 **Dark Mode** - Toggle between light and dark themes
- 📁 **Request Grouping** - Group requests by domain for better organization
- ⭐ **Favorites** - Bookmark important requests for quick access
- 📸 **Share as Image** - Export request details as shareable images
- 🔍 **Search & Filter** - Filter by status, method, and search by URL
- 📤 **Export Options** - Copy as JSON/HAR or save to file
- 🔄 **cURL Generation** - Generate cURL commands for any request
- 🔁 **Replay Requests** - Re-send any captured request
- 🔌 **Callbacks & Integrations** - Integrate with Sentry, Firebase, or custom webhooks
- 🎯 **Smart Filters** - Capture only errors, slow requests, or specific endpoints
- 🌲 **Tree-Shakable** - Zero footprint in release builds
- 📊 **Detailed Metrics** - Request time, response size, duration with color-coded indicators
- 🪶 **Lightweight** - Native Android/iOS implementation, only 2 dependencies (Dio + screenshot)

## 📸 Screenshots

| Logs List                                                                                       | Log Detail                                                                                        | Dark Mode                                                                                   | Share as Image                                                                                  |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------- |
| ![Logs List](https://raw.githubusercontent.com/ricoerlan/netify/main/screenshots/logs_list.png) | ![Log Detail](https://raw.githubusercontent.com/ricoerlan/netify/main/screenshots/log_detail.png) | ![Share](https://raw.githubusercontent.com/ricoerlan/netify/main/screenshots/log_share.png) | ![Dark Mode](https://raw.githubusercontent.com/ricoerlan/netify/main/screenshots/dark_mode.png) |

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  netify: ^2.0.0
  dio: ^5.4.0 # Required peer dependency
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

```dart
import 'package:dio/dio.dart';
import 'package:netify/netify.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio();
  await Netify.init(dio: dio);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: Netify.navigatorKey, // ← Add this line
      home: HomePage(),
    );
  }
}
```

That's it! 🎉 The floating bubble will appear automatically.

## 📖 API Reference

### Initialize

```dart
// Basic initialization
await Netify.init(dio: dio);

// With custom configuration
await Netify.init(
  dio: dio,
  enable: kDebugMode, // Only enable in debug mode
  config: NetifyConfig(
    maxLogs: 1000,
    entryMode: NetifyEntryMode.bubble,
    callbacks: NetifyCallbacks(
      onError: (log) => print('Request failed: ${log.url}'),
    ),
    filters: NetifyFilters(
      captureStatusCodes: [400, 401, 403, 404, 500],
    ),
  ),
);
```

### Access Logs

```dart
// Get logs stream
Stream<List<NetworkLog>> stream = Netify.logsStream;

// Get current logs
List<NetworkLog> logs = Netify.logs;

// Get log count
int count = Netify.logCount;
```

### Search & Filter

```dart
// Search logs by URL, method, or status
List<NetworkLog> results = Netify.searchLogs('api/users');
```

### Export Logs

```dart
// Export as JSON
String json = Netify.exportAsJson();

// Export as HAR format (for Chrome DevTools, Postman, etc.)
String har = Netify.exportAsHar();
```

### Generate cURL

```dart
// Generate cURL command for a request
String curl = Netify.generateCurl(log);
```

### Clear Logs

```dart
// Clear all logs
Netify.clearLogs();
```

### Callbacks & Integrations

Netify supports callbacks to integrate with external monitoring services:

```dart
// Basic callbacks
await Netify.init(
  dio: dio,
  config: NetifyConfig(
    callbacks: NetifyCallbacks(
      onRequest: (log) {
        print('Request sent: ${log.method} ${log.url}');
      },
      onResponse: (log) {
        print('Response received: ${log.statusCode}');
      },
      onError: (log) {
        print('Request failed: ${log.error}');
      },
      onSlowRequest: (log, threshold) {
        print('Slow request: ${log.url} took ${log.duration}');
      },
    ),
  ),
);
```

#### Sentry Integration

```dart
import 'package:netify/netify.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

await Netify.init(
  dio: dio,
  config: NetifyConfig(
    callbacks: NetifyCallbacks(
      onError: (log) {
        Sentry.captureException(
          Exception('Network request failed: ${log.url}'),
          hint: Hint.withMap({
            'statusCode': log.statusCode,
            'method': log.method,
          }),
        );
      },
    ),
  ),
);
```

#### Firebase Performance Integration

```dart
import 'package:firebase_performance/firebase_performance.dart';

final metrics = <String, HttpMetric>{};

await Netify.init(
  dio: dio,
  config: NetifyConfig(
    callbacks: NetifyCallbacks(
      onRequest: (log) {
        final metric = FirebasePerformance.instance.newHttpMetric(
          log.url,
          HttpMethod.Get,
        );
        metric.start();
        metrics[log.id] = metric;
      },
      onResponse: (log) {
        final metric = metrics.remove(log.id);
        if (metric != null && log.statusCode != null) {
          metric.httpResponseCode = log.statusCode!;
          metric.stop();
        }
      },
    ),
  ),
);
```

### Filters

Control which requests are captured:

```dart
await Netify.init(
  dio: dio,
  config: NetifyConfig(
    filters: NetifyFilters(
      // Only capture error responses
      captureStatusCodes: [400, 401, 403, 404, 500, 502, 503],

      // Only capture slow requests (>3 seconds)
      captureSlowRequests: Duration(seconds: 3),

      // Ignore health check endpoints
      ignorePaths: ['/health', '/metrics', '/ping'],

      // Ignore analytics domains
      ignoreHosts: ['analytics.google.com', 'firebase.google.com'],
    ),
  ),
);
```

### Dispose

```dart
// Dispose resources
await Netify.dispose();
```

## 📱 UI Components

### NetifyPanel

The main UI for viewing all captured network requests:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => const NetifyPanel()),
);
```

### LogDetailPage

Detailed view of a single request (automatically opened from NetifyPanel):

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => LogDetailPage(log: networkLog)),
);
```

## ⚙️ Configuration Options

### NetifyConfig

| Option      | Type              | Default                  | Description                                |
| ----------- | ----------------- | ------------------------ | ------------------------------------------ |
| `maxLogs`   | `int`             | `500`                    | Maximum number of logs to keep in memory   |
| `entryMode` | `NetifyEntryMode` | `NetifyEntryMode.bubble` | Entry point mode (`bubble` or `none`)      |
| `callbacks` | `NetifyCallbacks` | `null`                   | Callbacks for integrations                 |
| `filters`   | `NetifyFilters`   | `null`                   | Filters for controlling what gets captured |

### NetifyCallbacks

| Callback        | Parameters               | Description                           |
| --------------- | ------------------------ | ------------------------------------- |
| `onRequest`     | `NetworkLog`             | Called when a request is sent         |
| `onResponse`    | `NetworkLog`             | Called when a response is received    |
| `onError`       | `NetworkLog`             | Called when a request fails           |
| `onSlowRequest` | `NetworkLog`, `Duration` | Called when request exceeds threshold |

### NetifyFilters

| Filter                | Type           | Description                            |
| --------------------- | -------------- | -------------------------------------- |
| `captureStatusCodes`  | `List<int>`    | Only capture these HTTP status codes   |
| `captureSlowRequests` | `Duration`     | Only capture requests slower than this |
| `ignorePaths`         | `List<String>` | Ignore requests to these URL paths     |
| `ignoreHosts`         | `List<String>` | Ignore requests to these hosts         |

## 🏗️ Architecture

Netify follows Clean Architecture principles:

```
lib/
├── netify.dart              # Public API
└── src/
    ├── core/                # Domain layer (pure Dart)
    │   ├── entities/        # Domain models
    │   └── repositories/    # Abstract contracts
    ├── data/                # Data layer
    │   ├── interceptor/     # Dio interceptor
    │   ├── repositories/    # Concrete implementations
    │   └── services/        # External services
    └── presentation/        # Presentation layer
        ├── pages/           # UI screens
        ├── widgets/         # Reusable widgets
        └── theme/           # Design tokens
```

## 🔒 Privacy & Security

- All data is stored **in-memory only** - nothing persists to disk
- Automatically disabled in release builds (when `showOnlyInDebug: true`)
- No data is sent to external servers
- Logs are cleared when the app is closed

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
