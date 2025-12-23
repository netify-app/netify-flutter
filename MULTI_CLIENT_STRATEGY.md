# 🔌 Multi-Client Compatibility Strategy

**Goal**: Make Netify compatible with multiple HTTP clients without bloating user dependencies.

**Status**: Planning Phase  
**Target**: v3.0.0

---

## 📋 Overview

Currently, Netify only supports Dio. This document outlines the strategy to support:

### Phase 1 (v3.0.0) - Top 3 Most Popular

1. ✅ **Dio** (current) - ~90% of Flutter HTTP usage
2. 🆕 **http** (dart:io standard) - Official Dart HTTP client
3. 🆕 **GraphQL** (graphql_flutter) - Growing GraphQL adoption

### Phase 2 (v3.1.0) - Additional Clients

4. 🔮 **Chopper** (type-safe REST client)
5. 🔮 **Retrofit** (uses Dio internally, can reuse Dio adapter)

---

## 🎯 Architecture: Adapter Pattern

### Core Principle

**Separate core functionality from client-specific implementations.**

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
        │                       │
┌───────┴────────┐    ┌────────┴────────┐
│netify_chopper  │    │ netify_graphql  │
└────────────────┘    └─────────────────┘
```

---

## 📦 Package Structure

### Option A: Monorepo with Separate Packages (Recommended)

```
netify-app/
├── packages/
│   ├── netify_core/           # Core package (no HTTP deps)
│   │   ├── lib/
│   │   │   ├── netify_core.dart
│   │   │   └── src/
│   │   │       ├── entities/
│   │   │       │   ├── network_log.dart
│   │   │       │   └── netify_config.dart
│   │   │       ├── repositories/
│   │   │       │   └── log_repository.dart
│   │   │       ├── callbacks/
│   │   │       ├── filters/
│   │   │       └── presentation/
│   │   └── pubspec.yaml
│   │
│   ├── netify_dio/            # Dio adapter
│   │   ├── lib/
│   │   │   ├── netify_dio.dart
│   │   │   └── src/
│   │   │       └── dio_adapter.dart
│   │   └── pubspec.yaml
│   │
│   ├── netify_http/           # http adapter
│   │   ├── lib/
│   │   │   ├── netify_http.dart
│   │   │   └── src/
│   │   │       └── http_adapter.dart
│   │   └── pubspec.yaml
│   │
│   ├── netify_chopper/        # Chopper adapter
│   │   └── ...
│   │
│   └── netify_graphql/        # GraphQL adapter
│       └── ...
│
└── flutter/netify/            # Legacy (deprecated or alias)
```

### Option B: Keep Current Structure (Backward Compatible)

```
flutter/netify/                # Main package (includes Dio)
├── lib/
│   ├── netify.dart           # Exports Dio implementation
│   ├── netify_http.dart      # Exports http implementation
│   ├── netify_chopper.dart   # Exports Chopper implementation
│   └── src/
│       ├── core/             # Shared core
│       └── adapters/         # Client-specific adapters
│           ├── dio_adapter.dart
│           ├── http_adapter.dart
│           └── chopper_adapter.dart
└── pubspec.yaml              # All deps as optional
```

---

## 🔧 Implementation Details

### 1. Core Package (`netify_core`)

**Dependencies**: Zero HTTP client dependencies

```yaml
name: netify_core
description: Core network inspection functionality for Flutter
version: 3.0.0

dependencies:
  flutter:
    sdk: flutter
  screenshot: ^2.1.0
  rxdart: ^0.27.0 # For real-time stream replay behavior
```

**Exports**:

- `NetworkLog` - Universal data model
- `LogRepository` - Storage interface
- `NetifyCallbacks` - Callback system
- `NetifyFilters` - Filtering logic
- `NetifyPanel` - UI components
- `NetifyAdapter` - Base adapter interface

### 2. Adapter Interface

```dart
// netify_core/lib/src/adapters/netify_adapter.dart

abstract class NetifyAdapter {
  final LogRepository repository;
  final NetifyConfig config;

  NetifyAdapter({
    required this.repository,
    required this.config,
  });

  /// Called when adapter is attached
  void attach();

  /// Called when adapter is detached
  void detach();

  /// Manually capture a request (optional)
  void captureRequest(NetworkLog log) {
    if (config.filters?.shouldCaptureRequest(log) ?? true) {
      repository.addLog(log);
      config.callbacks?.onRequest?.call(log);
    }
  }

  /// Manually capture a response (optional)
  void captureResponse(NetworkLog log) {
    if (config.filters?.shouldCapture(log) ?? true) {
      repository.updateLog(log);
      config.callbacks?.onResponse?.call(log);
    }
  }

  /// Manually capture an error (optional)
  void captureError(NetworkLog log) {
    if (config.filters?.shouldCapture(log) ?? true) {
      repository.updateLog(log);
      config.callbacks?.onError?.call(log);
    }
  }
}
```

### 3. Dio Adapter (`netify_dio`)

**Dependencies**:

```yaml
name: netify_dio
description: Dio adapter for Netify network inspector
version: 3.0.0

dependencies:
  netify_core: ^3.0.0
  dio: ^5.4.0
```

**Implementation**:

```dart
// netify_dio/lib/src/dio_adapter.dart

class NetifyDioAdapter extends NetifyAdapter {
  final Dio dio;
  late final NetifyInterceptor _interceptor;

  NetifyDioAdapter({
    required this.dio,
    required super.repository,
    required super.config,
  });

  @override
  void attach() {
    _interceptor = NetifyInterceptor(
      logRepository: repository,
      config: config,
    );
    dio.interceptors.add(_interceptor);
  }

  @override
  void detach() {
    dio.interceptors.remove(_interceptor);
  }
}

// Public API
class NetifyDio {
  static Future<void> init({
    required Dio dio,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) return;

    final repository = LogRepositoryImpl(config: config);
    final adapter = NetifyDioAdapter(
      dio: dio,
      repository: repository,
      config: config,
    );

    await Netify.initWithAdapter(adapter);
  }
}
```

### 4. HTTP Adapter (`netify_http`)

**Dependencies**:

```yaml
name: netify_http
description: http package adapter for Netify network inspector
version: 3.0.0

dependencies:
  netify_core: ^3.0.0
  http: ^1.1.0
```

**Implementation**:

```dart
// netify_http/lib/src/http_adapter.dart

class NetifyHttpClient extends BaseClient {
  final Client _inner;
  final NetifyAdapter _adapter;

  NetifyHttpClient(this._inner, this._adapter);

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final log = NetworkLog(
      id: _generateId(),
      method: request.method,
      url: request.url.toString(),
      requestHeaders: request.headers,
      requestTime: DateTime.now(),
    );

    _adapter.captureRequest(log);

    try {
      final response = await _inner.send(request);
      final responseBody = await response.stream.toBytes();

      final updatedLog = log.copyWith(
        statusCode: response.statusCode,
        responseHeaders: response.headers,
        responseBody: utf8.decode(responseBody),
        responseTime: DateTime.now(),
        duration: DateTime.now().difference(log.requestTime),
      );

      _adapter.captureResponse(updatedLog);

      return StreamedResponse(
        Stream.value(responseBody),
        response.statusCode,
        headers: response.headers,
      );
    } catch (e) {
      final errorLog = log.copyWith(
        error: e.toString(),
        responseTime: DateTime.now(),
        duration: DateTime.now().difference(log.requestTime),
      );
      _adapter.captureError(errorLog);
      rethrow;
    }
  }
}

// Public API
class NetifyHttp {
  static Future<Client> init({
    Client? client,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) return client ?? Client();

    final repository = LogRepositoryImpl(config: config);
    final adapter = NetifyHttpAdapter(
      repository: repository,
      config: config,
    );

    await Netify.initWithAdapter(adapter);

    return NetifyHttpClient(client ?? Client(), adapter);
  }
}
```

### 5. Chopper Adapter (`netify_chopper`)

**Dependencies**:

```yaml
name: netify_chopper
description: Chopper adapter for Netify network inspector
version: 3.0.0

dependencies:
  netify_core: ^3.0.0
  chopper: ^7.0.0
```

**Implementation**:

```dart
// netify_chopper/lib/src/chopper_adapter.dart

class NetifyChopperInterceptor implements RequestInterceptor, ResponseInterceptor {
  final NetifyAdapter adapter;

  NetifyChopperInterceptor(this.adapter);

  @override
  FutureOr<Request> onRequest(Request request) {
    final log = NetworkLog(
      id: request.hashCode.toString(),
      method: request.method,
      url: request.url,
      requestHeaders: request.headers,
      requestBody: request.body,
      requestTime: DateTime.now(),
    );

    adapter.captureRequest(log);
    return request;
  }

  @override
  FutureOr<Response> onResponse(Response response) {
    // Capture response logic
    return response;
  }
}

// Public API
class NetifyChopper {
  static Future<void> init({
    required ChopperClient chopper,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) return;

    final repository = LogRepositoryImpl(config: config);
    final adapter = NetifyChopperAdapter(
      repository: repository,
      config: config,
    );

    chopper.interceptors.add(NetifyChopperInterceptor(adapter));
    await Netify.initWithAdapter(adapter);
  }
}
```

### 6. GraphQL Adapter (`netify_graphql`)

**Dependencies**:

```yaml
name: netify_graphql
description: GraphQL adapter for Netify network inspector
version: 3.0.0

dependencies:
  netify_core: ^3.0.0
  graphql_flutter: ^5.1.0
```

**Implementation**:

```dart
// netify_graphql/lib/src/graphql_adapter.dart

class NetifyGraphQLLink extends Link {
  final NetifyAdapter adapter;

  NetifyGraphQLLink(this.adapter);

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final log = NetworkLog(
      id: request.hashCode.toString(),
      method: 'GRAPHQL',
      url: request.context.entry<HttpLinkHeaders>()?.headers.toString() ?? '',
      requestBody: request.operation.document.toString(),
      requestTime: DateTime.now(),
    );

    adapter.captureRequest(log);

    await for (final response in forward!(request)) {
      final updatedLog = log.copyWith(
        responseBody: response.data,
        responseTime: DateTime.now(),
        duration: DateTime.now().difference(log.requestTime),
      );

      if (response.errors?.isNotEmpty ?? false) {
        adapter.captureError(updatedLog.copyWith(
          error: response.errors!.map((e) => e.message).join(', '),
        ));
      } else {
        adapter.captureResponse(updatedLog);
      }

      yield response;
    }
  }
}

// Public API
class NetifyGraphQL {
  static Future<Link> init({
    required Link link,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) return link;

    final repository = LogRepositoryImpl(config: config);
    final adapter = NetifyGraphQLAdapter(
      repository: repository,
      config: config,
    );

    await Netify.initWithAdapter(adapter);
    return Link.from([NetifyGraphQLLink(adapter), link]);
  }
}
```

---

## 👥 User Experience

### Dio Users

```dart
import 'package:netify_dio/netify_dio.dart';

void main() async {
  final dio = Dio();
  await NetifyDio.init(dio: dio);

  runApp(MyApp());
}
```

**pubspec.yaml**:

```yaml
dependencies:
  netify_dio: ^3.0.0
  dio: ^5.4.0
```

### HTTP Users

```dart
import 'package:netify_http/netify_http.dart';

void main() async {
  final client = await NetifyHttp.init();

  // Use client for all requests
  final response = await client.get(Uri.parse('https://api.example.com'));

  runApp(MyApp());
}
```

**pubspec.yaml**:

```yaml
dependencies:
  netify_http: ^3.0.0
  http: ^1.1.0
```

### Chopper Users

```dart
import 'package:netify_chopper/netify_chopper.dart';

void main() async {
  final chopper = ChopperClient(
    baseUrl: Uri.parse('https://api.example.com'),
    services: [MyService.create()],
  );

  await NetifyChopper.init(chopper: chopper);

  runApp(MyApp());
}
```

**pubspec.yaml**:

```yaml
dependencies:
  netify_chopper: ^3.0.0
  chopper: ^7.0.0
```

### GraphQL Users

```dart
import 'package:netify_graphql/netify_graphql.dart';

void main() async {
  final httpLink = HttpLink('https://api.example.com/graphql');
  final link = await NetifyGraphQL.init(link: httpLink);

  final client = GraphQLClient(
    cache: GraphQLCache(),
    link: link,
  );

  runApp(MyApp());
}
```

**pubspec.yaml**:

```yaml
dependencies:
  netify_graphql: ^3.0.0
  graphql_flutter: ^5.1.0
```

---

## 📊 Dependency Matrix

### v3.0.0 (Initial Release)

| Package          | Core | Dio | http | GraphQL |
| ---------------- | ---- | --- | ---- | ------- |
| `netify_core`    | ✅   | ❌  | ❌   | ❌      |
| `netify_dio`     | ✅   | ✅  | ❌   | ❌      |
| `netify_http`    | ✅   | ❌  | ✅   | ❌      |
| `netify_graphql` | ✅   | ❌  | ❌   | ✅      |

### v3.1.0 (Future)

| Package          | Core | Dio | http | Chopper | GraphQL |
| ---------------- | ---- | --- | ---- | ------- | ------- |
| `netify_chopper` | ✅   | ❌  | ❌   | ✅      | ❌      |

**Note**: Retrofit uses Dio internally, so users can use `netify_dio` directly.

**Result**: Users only install what they need! 🎉

---

### 🎯 v3.0.0 - Top 3 Clients (6 weeks)

#### Phase 1: Core Extraction (Week 1-2)

- [ ] Extract core functionality to `netify_core`
- [ ] Create `NetifyAdapter` base class
- [ ] Move UI components to core
- [ ] Update `NetworkLog` to be client-agnostic

#### Phase 2: Dio Adapter (Week 2-3)

- [ ] Refactor current Dio implementation
- [ ] Create `netify_dio` package
- [ ] Implement `NetifyDioAdapter`
- [ ] Test backward compatibility
- [ ] Migration guide for existing users

#### Phase 3: HTTP Adapter (Week 3-4)

- [ ] Create `netify_http` package
- [ ] Implement `NetifyHttpClient` wrapper
- [ ] Handle request/response interception
- [ ] Add comprehensive tests
- [ ] Example app integration

#### Phase 4: GraphQL Adapter (Week 4-5)

- [ ] Create `netify_graphql` package
- [ ] Implement GraphQL Link
- [ ] Handle queries/mutations/subscriptions
- [ ] Add tests
- [ ] Example app integration

#### Phase 5: Documentation & Release (Week 5-6)

- [ ] Update README for all packages
- [ ] Create migration guide
- [ ] Write integration examples
- [ ] Publish to pub.dev
- [ ] Announce v3.0.0 release

---

### 🔮 v3.1.0 - Additional Clients (Future)

#### Chopper Support

- [ ] Create `netify_chopper` package
- [ ] Implement Chopper interceptor
- [ ] Add tests and examples

#### Retrofit Support

- [ ] Document Retrofit usage (uses Dio internally)
- [ ] Create helper/wrapper if needed
- [ ] Add example

---

## 🔄 Migration Strategy

### For Existing Users (Dio)

**Option A: No changes required** (if we keep `netify` as Dio package)

```yaml
dependencies:
  netify: ^3.0.0 # Still works!
```

**Option B: Explicit migration** (cleaner)

```yaml
dependencies:
  netify_dio: ^3.0.0 # New package name
```

### Breaking Changes

- **v3.0.0**: Introduce adapter pattern
- Provide deprecation warnings in v2.x
- Support both APIs for 6 months

---

## ✅ Success Criteria

### v3.0.0

- [ ] Zero dependency bloat for users
- [ ] Top 3 HTTP clients supported (Dio, http, GraphQL)
- [ ] Backward compatible for Dio users
- [ ] Comprehensive documentation
- [ ] 90%+ test coverage per adapter
- [ ] Published to pub.dev
- [ ] Migration guide available
- [ ] Example apps for each adapter

### v3.1.0 (Future)

- [ ] Chopper support added
- [ ] Retrofit documentation/example
- [ ] Community feedback incorporated

---

## 🤔 Open Questions

1. **Package naming**: `netify_dio` vs `netify_for_dio`?

   - **Recommendation**: `netify_dio` (shorter, cleaner)

2. **Versioning**: Keep all packages in sync or independent?

   - **Recommendation**: Sync major versions, independent minor/patch

3. **Monorepo**: Use melos for package management?

   - **Recommendation**: Yes, use melos for easier development

4. **Retrofit**: Separate adapter or document Dio usage?

   - **Decision**: Document Dio usage (Retrofit wraps Dio, so `netify_dio` works)

5. **Legacy support**: How long to maintain v2.x?

   - **Recommendation**: 6 months with deprecation warnings

6. **Priority order**: Which 3 clients first?

   - **Decision**: Dio → http → GraphQL (most popular)

7. **RxDart**: Should we use RxDart for streams?

   - **Decision**: Yes, but minimal usage (BehaviorSubject only)
   - **Reason**: Real-time requirement needs replay behavior for late subscribers
   - **Scope**: Only use `BehaviorSubject`, not full reactive operators
   - **Benefit**: New UI screens instantly show current state
   - **Trade-off**: +1 lightweight dependency (~50KB) for better UX

8. **Dependency Injection**: Should we use get_it/injectable?

   - **Decision**: No, keep manual constructor injection
   - **Reason**: Simple enough, no need for service locator
   - **Benefit**: Zero extra dependencies, easier to understand

---

## 📚 References

- [Adapter Pattern](https://refactoring.guru/design-patterns/adapter)
- [Flutter Package Development](https://docs.flutter.dev/development/packages-and-plugins/developing-packages)
- [Melos Monorepo Tool](https://melos.invertase.dev/)
- [Pub.dev Publishing](https://dart.dev/tools/pub/publishing)

---

**Next Steps**: Review this strategy and decide on package structure (Option A vs B).
