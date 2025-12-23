# netify_dio Example

A complete example demonstrating how to use `netify_dio` with the Dio HTTP client.

## Features Demonstrated

- ✅ Basic Netify initialization with Dio
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
await NetifyDio.init(
  dio: dio,
  config: NetifyConfig(
    entryMode: EntryMode.bubble,
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
  navigatorKey: NetifyDio.navigatorKey, // Required!
  home: MyHomePage(),
)
```

### Make Requests

```dart
// Netify automatically captures all Dio requests
final response = await dio.get('/posts');
```

## Learn More

- [netify_dio Documentation](https://pub.dev/packages/netify_dio)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Netify Repository](https://github.com/netify-app/netify-flutter)
