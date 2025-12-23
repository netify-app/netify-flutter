# Netify HTTP

HTTP (dart:io) adapter for Netify network inspector.

## Installation

```yaml
dependencies:
  netify_http: ^3.0.0
  http: ^1.1.0
```

## Usage

### Basic Setup

```dart
import 'package:http/http.dart' as http;
import 'package:netify_http/netify_http.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = http.Client();
  await NetifyHttp.init(client: client);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NetifyHttp.navigatorKey,
      home: HomePage(),
    );
  }
}
```

### Making Requests

Use the wrapped client from `NetifyHttp.client`:

```dart
// GET request
final response = await NetifyHttp.client.get(
  Uri.parse('https://api.example.com/users'),
);

// POST request
final response = await NetifyHttp.client.post(
  Uri.parse('https://api.example.com/users'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({'name': 'John Doe'}),
);

// PUT request
final response = await NetifyHttp.client.put(
  Uri.parse('https://api.example.com/users/1'),
  body: jsonEncode({'name': 'Jane Doe'}),
);

// DELETE request
final response = await NetifyHttp.client.delete(
  Uri.parse('https://api.example.com/users/1'),
);
```

### With Callbacks

```dart
await NetifyHttp.init(
  client: client,
  config: NetifyConfig(
    callbacks: NetifyCallbacks(
      onRequest: (log) {
        print('Request: ${log.method} ${log.url}');
      },
      onResponse: (log) {
        print('Response: ${log.statusCode}');
      },
      onError: (log) {
        print('Error: ${log.error}');
      },
      onSlowRequest: (log, threshold) {
        print('Slow request detected: ${log.duration}');
      },
    ),
  ),
);
```

### With Filters

```dart
await NetifyHttp.init(
  client: client,
  config: NetifyConfig(
    filters: NetifyFilters(
      captureStatusCodes: [200, 201, 400, 401, 403, 404, 500],
      captureSlowRequests: Duration(seconds: 3),
      ignorePaths: ['/health', '/metrics'],
      ignoreHosts: ['analytics.example.com'],
    ),
  ),
);
```

## Features

- 📡 Automatic request/response capture via wrapped HTTP client
- 🔌 Callback support for monitoring integrations
- 🎯 Smart filters for selective capturing
- 🫧 Floating bubble UI
- 📊 Detailed request/response inspection
- 📤 Export logs as JSON or HAR format
- 🔄 Replay requests
- 📋 Generate cURL commands

## API

### Access Logs

```dart
// Stream of all logs
NetifyHttp.logsStream.listen((logs) {
  print('Total logs: ${logs.length}');
});

// Current logs
final logs = NetifyHttp.logs;

// Search logs
final results = NetifyHttp.searchLogs('api/users');

// Favorites
NetifyHttp.toggleFavorite(logId);
final favorites = NetifyHttp.favoriteLogs;
```

### Export

```dart
// Export as JSON
final json = NetifyHttp.exportAsJson();

// Export as HAR (HTTP Archive)
final har = NetifyHttp.exportAsHar();

// Generate cURL command
final curl = NetifyHttp.generateCurl(log);
```

### Replay

```dart
// Replay a request
await NetifyHttp.replayRequest(log);
```

### Show Inspector

```dart
// Show the Netify panel
NetifyHttp.show(context);
```

## Differences from netify_dio

- Uses `http.Client` wrapper instead of interceptors
- Supports standard HTTP methods (GET, POST, PUT, PATCH, DELETE)
- Works with any code using the `http` package
- Slightly different initialization (wraps existing client)

## Example

See the [example](example/) directory for a complete working example.

## License

MIT
