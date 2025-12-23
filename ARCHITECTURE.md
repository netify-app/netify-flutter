# Netify Multi-Client Architecture

## Overview

Netify now uses a **monorepo architecture** with separate packages for different HTTP clients. This allows users to only install the dependencies they need.

## Package Structure

```
netify-app/
├── packages/
│   ├── netify_core/      # Core functionality (no HTTP client deps)
│   ├── netify_dio/       # Dio adapter
│   ├── netify_http/      # http adapter (coming soon)
│   └── netify_graphql/   # GraphQL adapter (coming soon)
├── flutter/netify/       # Legacy package (for backward compatibility)
└── melos.yaml           # Monorepo management
```

## Packages

### netify_core (v3.0.0)

**Core functionality - client-agnostic**

Dependencies:

- `flutter`
- `screenshot` (for share as image)
- `rxdart` (for real-time streams)

Exports:

- `NetworkLog` - Universal data model
- `LogRepository` - Storage interface
- `NetifyCallbacks` - Callback system
- `NetifyFilters` - Smart filters
- `NetifyAdapter` - Base adapter class
- UI components (NetifyPanel, LogDetailPage, etc.)

### netify_dio (v3.0.0)

**Dio HTTP client adapter**

Dependencies:

- `netify_core`
- `dio ^5.4.0`

Usage:

```dart
import 'package:netify_dio/netify_dio.dart';

await NetifyDio.init(dio: dio);
```

### netify_http (v3.0.0) - Coming Soon

**dart:io http package adapter**

Dependencies:

- `netify_core`
- `http ^1.1.0`

### netify_graphql (v3.0.0) - Coming Soon

**GraphQL client adapter**

Dependencies:

- `netify_core`
- `graphql_flutter ^5.1.0`

## Adapter Pattern

All adapters extend the base `NetifyAdapter` class:

```dart
abstract class NetifyAdapter {
  final LogRepository repository;
  final NetifyConfig config;

  void attach();    // Setup interceptors
  void detach();    // Cleanup interceptors

  void captureRequest(NetworkLog log);
  void captureResponse(NetworkLog log);
  void captureError(NetworkLog log);
}
```

## Development

### Using Melos

```bash
# Install melos
dart pub global activate melos

# Bootstrap all packages
melos bootstrap

# Run tests on all packages
melos run test

# Analyze all packages
melos run analyze

# Format all packages
melos run format
```

### Adding a New Adapter

1. Create package directory: `packages/netify_[client]/`
2. Add `pubspec.yaml` with `netify_core` dependency
3. Implement adapter extending `NetifyAdapter`
4. Create public API class (e.g., `NetifyHttp`)
5. Add README with usage examples
6. Run `flutter pub get`

## Migration from v2.x

Existing users can continue using the legacy `flutter/netify` package, or migrate to the new structure:

**Before (v2.x):**

```yaml
dependencies:
  netify: ^2.1.0
```

**After (v3.0.0):**

```yaml
dependencies:
  netify_dio: ^3.0.0
```

The API remains the same, just change the import:

```dart
// Before
import 'package:netify/netify.dart';
await Netify.init(dio: dio);

// After
import 'package:netify_dio/netify_dio.dart';
await NetifyDio.init(dio: dio);
```

## Benefits

✅ **Zero bloat** - Users only install what they need  
✅ **Easy to extend** - Add new clients by creating adapters  
✅ **Backward compatible** - Legacy package still works  
✅ **Type-safe** - Each adapter handles client-specific types  
✅ **Maintainable** - Core logic separated from client-specific code

## Status

- ✅ **netify_core** - Complete
- ✅ **netify_dio** - Complete
- 🚧 **netify_http** - Planned for v3.1.0
- 🚧 **netify_graphql** - Planned for v3.1.0
- 🚧 **netify_chopper** - Planned for v3.2.0

## Next Steps

1. Test netify_dio with example app
2. Implement netify_http adapter
3. Implement netify_graphql adapter
4. Update documentation
5. Publish to pub.dev
