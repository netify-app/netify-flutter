# Netify v3.0.0 - Multi-Client Architecture 🎉

**Release Date**: December 23, 2025  
**Repository**: https://github.com/netify-app/netify-flutter

---

## 🎯 Major Release: Multi-Client Architecture

We're excited to announce Netify v3.0.0, featuring a complete architectural redesign to support multiple HTTP clients!

### **What's New**

#### 🏗️ Multi-Client Support

Netify now works with multiple HTTP clients through a modular adapter pattern:

- ✅ **netify_dio** - For Dio users
- ✅ **netify_http** - For http package users
- 📋 **netify_graphql** - Coming soon

#### 📦 Three Separate Packages

Install only what you need - zero dependency bloat!

| Package                                             | Version | Description                          |
| --------------------------------------------------- | ------- | ------------------------------------ |
| [netify_core](https://pub.dev/packages/netify_core) | 3.0.0   | Core functionality (client-agnostic) |
| [netify_dio](https://pub.dev/packages/netify_dio)   | 3.0.0   | Dio HTTP client adapter              |
| [netify_http](https://pub.dev/packages/netify_http) | 3.0.0   | HTTP package adapter                 |

---

## ✨ New Features

### 1. **Callbacks System**

Integrate with monitoring services like Sentry, Firebase, Datadog:

```dart
await NetifyDio.init(
  dio: dio,
  config: NetifyConfig(
    callbacks: NetifyCallbacks(
      onRequest: (log) => print('Request: ${log.url}'),
      onResponse: (log) => print('Response: ${log.statusCode}'),
      onError: (log) => yourAnalytics.trackError(log),
      onSlowRequest: (log, threshold) => yourMonitoring.alert(log),
    ),
  ),
);
```

### 2. **Smart Filters**

Capture only what matters:

```dart
NetifyConfig(
  filters: NetifyFilters(
    captureStatusCodes: [400, 401, 403, 404, 500],
    captureSlowRequests: Duration(seconds: 3),
    ignorePaths: ['/health', '/metrics'],
    ignoreHosts: ['analytics.example.com'],
  ),
)
```

### 3. **Export Functionality**

- **JSON Export** - Export logs as JSON
- **HAR Export** - HTTP Archive format
- **cURL Generation** - Generate cURL commands
- **Request Replay** - Re-send any captured request

### 4. **Production-Ready**

- Lightweight monitoring mode
- Privacy controls
- Zero overhead option
- Integration-ready

---

## 🚀 Quick Start

### For Dio Users

```yaml
dependencies:
  netify_dio: ^3.0.0
  dio: ^5.4.0
```

```dart
import 'package:netify_dio/netify_dio.dart';

await NetifyDio.init(dio: dio);
```

### For HTTP Package Users

```yaml
dependencies:
  netify_http: ^3.0.0
  http: ^1.1.0
```

```dart
import 'package:netify_http/netify_http.dart';

await NetifyHttp.init(client: client);
// Use NetifyHttp.client for requests
```

---

## 💥 Breaking Changes

### Package Renamed

**Before (v2.x)**:

```yaml
dependencies:
  netify: ^2.0.0
```

**After (v3.0.0)**:

```yaml
dependencies:
  netify_dio: ^3.0.0 # For Dio users
  # OR
  netify_http: ^3.0.0 # For HTTP users
```

### Import Changes

**Before**:

```dart
import 'package:netify/netify.dart';
await Netify.init(dio: dio);
```

**After**:

```dart
import 'package:netify_dio/netify_dio.dart';
await NetifyDio.init(dio: dio);
```

### API Compatibility

The API remains largely the same - just change the import and class name. All existing features are preserved.

---

## 📚 Documentation

- **Repository**: https://github.com/netify-app/netify-flutter
- **Architecture**: [ARCHITECTURE.md](https://github.com/netify-app/netify-flutter/blob/main/ARCHITECTURE.md)
- **Migration Guide**: [MIGRATION_PLAN.md](https://github.com/netify-app/netify-flutter/blob/main/MIGRATION_PLAN.md)
- **Contributing**: [CONTRIBUTING.md](https://github.com/netify-app/netify-flutter/blob/main/CONTRIBUTING.md)

### Package Documentation

- [netify_core README](https://pub.dev/packages/netify_core)
- [netify_dio README](https://pub.dev/packages/netify_dio)
- [netify_http README](https://pub.dev/packages/netify_http)

---

## 🎯 Benefits

### 1. **Zero Dependency Bloat**

Users only install the HTTP client they use. No unnecessary dependencies.

### 2. **Easy to Extend**

Add new HTTP clients by creating adapters. Clean, modular architecture.

### 3. **Backward Compatible**

Adapters maintain similar API to v2.x. Easy migration path.

### 4. **Type-Safe**

Each adapter handles client-specific types. Compile-time safety.

### 5. **Maintainable**

Core logic separated from client-specific code. Single responsibility principle.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│         netify_core                      │
│  - NetworkLog (universal data model)    │
│  - LogRepository                         │
│  - UI Components (NetifyPanel, etc.)    │
│  - Callbacks & Filters                   │
└─────────────────────────────────────────┘
                    ▲
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────┴────────┐    ┌────────┴────────┐
│  netify_dio    │    │  netify_http    │
│  (Dio adapter) │    │  (http adapter) │
└────────────────┘    └─────────────────┘
```

---

## 🐛 Bug Fixes

- Fixed memory leaks in log repository
- Improved performance for large log lists
- Fixed dark mode inconsistencies
- Resolved SSL certificate issues with proxy tools

---

## 🔧 Technical Details

### Dependencies

**netify_core**:

- flutter (SDK)
- screenshot: ^2.1.0
- rxdart: ^0.27.0

**netify_dio**:

- netify_core: ^3.0.0
- dio: ^5.4.0

**netify_http**:

- netify_core: ^3.0.0
- http: ^1.1.0

### Requirements

- Flutter: >=3.0.0
- Dart: >=3.0.0 <4.0.0

---

## 🙏 Acknowledgments

Built with ❤️ by [@ricoerlan](https://github.com/ricoerlan) and [contributors](https://github.com/netify-app/netify-flutter/graphs/contributors).

Special thanks to:

- The Flutter community for feedback and support
- All early adopters and testers
- Contributors who helped shape this release

---

## 🔮 What's Next

### v3.1.0 (Q2 2025)

- GraphQL adapter
- Additional HTTP client adapters
- Enhanced documentation
- Example apps

### v3.2.0 (Q3 2025)

- WebSocket support
- Advanced analytics
- Performance profiling
- Request mocking

### Future

- netify.dev website
- Netify Cloud (SaaS)
- Enterprise features
- Multi-platform support (React Native, iOS, Android, Web)

---

## 📞 Support

- **Issues**: https://github.com/netify-app/netify-flutter/issues
- **Discussions**: https://github.com/netify-app/netify-flutter/discussions
- **Email**: hello@netify.dev

---

## 📄 License

MIT License - see [LICENSE](https://github.com/netify-app/netify-flutter/blob/main/LICENSE)

---

**Thank you for using Netify!** 🎉

If you find Netify useful, please consider:

- ⭐ Starring the repository
- 📢 Sharing with other developers
- 🐛 Reporting bugs and suggesting features
- 🤝 Contributing to the project

---

**Published Packages**:

- https://pub.dev/packages/netify_core
- https://pub.dev/packages/netify_dio
- https://pub.dev/packages/netify_http
