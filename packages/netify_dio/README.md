# Netify Dio

Dio adapter for Netify network inspector.

## Installation

```yaml
dependencies:
  netify_dio: ^3.0.0
  dio: ^5.4.0
```

## Usage

```dart
import 'package:dio/dio.dart';
import 'package:netify_dio/netify_dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio();
  await NetifyDio.init(dio: dio);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NetifyDio.navigatorKey,
      home: HomePage(),
    );
  }
}
```

## Features

- 📡 Automatic request/response capture via Dio interceptor
- 🔌 Callback support for monitoring integrations
- 🎯 Smart filters for selective capturing
- 🫧 Floating bubble UI
- 📊 Detailed request/response inspection

For more information, see the [main Netify documentation](https://github.com/ricoerlan/netify).
