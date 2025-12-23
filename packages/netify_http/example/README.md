# netify_http Example

A complete example demonstrating how to use `netify_http` with the dart:io http package.

## Features Demonstrated

- ✅ Basic Netify initialization with http client
- ✅ GET, POST, PUT, DELETE requests
- ✅ Error handling and 404 responses
- ✅ Callbacks for request/response/error events
- ✅ Floating bubble UI
- ✅ Request inspection panel

## Running the Example

```bash
flutter pub get
flutter run
```

## What to Try

1. **Tap any button** to make an API call
2. **Watch the bubble** appear with request count
3. **Tap the bubble** to open the Netify panel
4. **Inspect requests** - see headers, body, response
5. **Try the error button** to see how errors are captured

## API Used

This example uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/), a free fake REST API for testing.

## Code Highlights

### Initialize Netify

```dart
await NetifyHttp.init(
  client: client,
  config: NetifyConfig(
    showNotification: true,
    callbacks: NetifyCallbacks(
      onRequest: (log) => print('Request: ${log.url}'),
      onResponse: (log) => print('Response: ${log.statusCode}'),
      onError: (log) => print('Error: ${log.error}'),
    ),
  ),
);
```

### Add Navigator Key

```dart
MaterialApp(
  navigatorKey: NetifyHttp.navigatorKey, // Required!
  home: MyHomePage(),
)
```

### Make Requests

```dart
// Use NetifyHttp.client instead of your http client
final response = await NetifyHttp.client.get(
  Uri.parse('https://api.example.com/posts'),
);
```

## Learn More

- [netify_http Documentation](https://pub.dev/packages/netify_http)
- [http Package Documentation](https://pub.dev/packages/http)
- [Netify Repository](https://github.com/netify-app/netify-flutter)
