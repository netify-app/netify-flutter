# Migration Plan: ricoerlan/netify → netify-app/netify-flutter

**Goal**: Move the current Flutter implementation to the new netify-app organization structure  
**Timeline**: Immediate (Q1 2025)  
**Status**: Planning

---

## 📋 Overview

### **Current State**

- **Repository**: `ricoerlan/netify`
- **Location**: `/Users/rico/Projects/flutter/package/netify-app/flutter/netify/`
- **Branch**: `feature/multi-client-architecture`
- **Packages**: netify_core, netify_dio, netify_http (all v3.0.0)
- **Status**: Complete, tested, ready for publication

### **Target State**

- **Organization**: `netify-app`
- **Repository**: `netify-app/netify-flutter`
- **Packages**: Same (netify_core, netify_dio, netify_http)
- **Status**: Published to pub.dev

---

## 🎯 Migration Steps

### **Phase 1: Create Organization Repository** ✅

#### **Step 1.1: Create netify-flutter Repository**

1. Go to https://github.com/orgs/netify-app/repositories
2. Click "New repository"
3. Repository name: `netify-flutter`
4. Description: "Universal network inspector for Flutter apps. Supports Dio, HTTP, and GraphQL clients."
5. Visibility: **Public**
6. Initialize: **Do NOT** initialize with README (we'll push existing code)
7. Create repository

#### **Step 1.2: Update Local Git Remote**

```bash
cd /Users/rico/Projects/flutter/package/netify-app/flutter/netify

# Add new remote
git remote add org https://github.com/netify-app/netify-flutter.git

# Verify remotes
git remote -v
# origin    https://github.com/ricoerlan/netify.git (fetch)
# origin    https://github.com/ricoerlan/netify.git (push)
# org       https://github.com/netify-app/netify-flutter.git (fetch)
# org       https://github.com/netify-app/netify-flutter.git (push)
```

#### **Step 1.3: Push to Organization**

```bash
# Push feature branch to organization
git push org feature/multi-client-architecture

# Create main branch from feature branch
git checkout -b main
git push org main

# Set org as default upstream
git branch --set-upstream-to=org/main main
```

---

### **Phase 2: Update Package Metadata** 📝

#### **Step 2.1: Update pubspec.yaml Files**

Update all three packages with new repository URLs:

**packages/netify_core/pubspec.yaml**:

```yaml
name: netify_core
description: Core network inspection functionality for Flutter. Client-agnostic foundation for Netify adapters.
version: 3.0.0
homepage: https://netify.dev
repository: https://github.com/netify-app/netify-flutter
issue_tracker: https://github.com/netify-app/netify-flutter/issues
documentation: https://netify.dev/docs

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  screenshot: ^2.1.0
  rxdart: ^0.27.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

**packages/netify_dio/pubspec.yaml**:

```yaml
name: netify_dio
description: Dio adapter for Netify network inspector. Beautiful in-app debugging for Dio HTTP client.
version: 3.0.0
homepage: https://netify.dev
repository: https://github.com/netify-app/netify-flutter
issue_tracker: https://github.com/netify-app/netify-flutter/issues
documentation: https://netify.dev/docs/dio

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  dio: ^5.4.0
  netify_core: ^3.0.0 # Change from path to version dependency

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

**packages/netify_http/pubspec.yaml**:

```yaml
name: netify_http
description: HTTP adapter for Netify network inspector. Beautiful in-app debugging for dart:io http package.
version: 3.0.0
homepage: https://netify.dev
repository: https://github.com/netify-app/netify-flutter
issue_tracker: https://github.com/netify-app/netify-flutter/issues
documentation: https://netify.dev/docs/http

environment:
  sdk: ">=3.0.0 <4.0.0"
  flutter: ">=3.0.0"

dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  netify_core: ^3.0.0 # Change from path to version dependency

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

#### **Step 2.2: Create Root README**

Create `/Users/rico/Projects/flutter/package/netify-app/flutter/netify/README.md`:

````markdown
# Netify for Flutter

Universal network inspector for Flutter apps. Supports multiple HTTP clients with beautiful in-app debugging UI.

## 📦 Packages

This repository contains multiple packages:

- **[netify_core](packages/netify_core)** - Core functionality (client-agnostic)
- **[netify_dio](packages/netify_dio)** - Dio adapter
- **[netify_http](packages/netify_http)** - HTTP package adapter
- **[netify_graphql](packages/netify_graphql)** - GraphQL adapter (coming soon)

## 🚀 Quick Start

### For Dio Users

```yaml
dependencies:
  netify_dio: ^3.0.0
```
````

```dart
import 'package:netify_dio/netify_dio.dart';

await NetifyDio.init(dio: dio);
```

### For HTTP Package Users

```yaml
dependencies:
  netify_http: ^3.0.0
```

```dart
import 'package:netify_http/netify_http.dart';

await NetifyHttp.init(client: client);
```

## 📚 Documentation

- **Website**: [netify.dev](https://netify.dev)
- **Docs**: [netify.dev/docs](https://netify.dev/docs)
- **API Reference**: [API.md](docs/API.md)
- **Architecture**: [ARCHITECTURE.md](ARCHITECTURE.md)

## 🤝 Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)

## 📄 License

MIT License - see [LICENSE](LICENSE)

````

---

### **Phase 3: Update Documentation** 📚

#### **Step 3.1: Update All README Files**

Update package-specific READMEs to reference new organization:

- Replace `ricoerlan/netify` with `netify-app/netify-flutter`
- Update documentation links to `netify.dev`
- Add organization badges

#### **Step 3.2: Update ARCHITECTURE.md**

Update repository references and add organization context.

#### **Step 3.3: Update IMPLEMENTATION_STATUS.md**

Update with final status and organization information.

#### **Step 3.4: Create CONTRIBUTING.md**

```markdown
# Contributing to Netify

Thank you for your interest in contributing to Netify!

## Getting Started

1. Fork the repository
2. Clone your fork
3. Create a feature branch
4. Make your changes
5. Submit a pull request

## Development Setup

```bash
# Clone the repository
git clone https://github.com/netify-app/netify-flutter.git
cd netify-flutter

# Install melos
dart pub global activate melos

# Bootstrap packages
melos bootstrap

# Run tests
melos test

# Run analysis
melos analyze
````

## Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Run `flutter analyze` before committing
- Maintain 80%+ test coverage

## Pull Request Process

1. Update documentation
2. Add tests for new features
3. Ensure all tests pass
4. Update CHANGELOG.md
5. Request review

## Questions?

- Open a [Discussion](https://github.com/netify-app/netify-flutter/discussions)
- Join our [Discord](https://discord.gg/netify)

Thank you! ❤️

````

---

### **Phase 4: Publish to pub.dev** 🚀

#### **Step 4.1: Prepare for Publication**

Before publishing, ensure:

1. ✅ All packages pass `flutter analyze`
2. ✅ All tests pass
3. ✅ CHANGELOG.md is up to date
4. ✅ README.md is complete
5. ✅ LICENSE file exists
6. ✅ pubspec.yaml metadata is correct

#### **Step 4.2: Publish netify_core**

```bash
cd packages/netify_core

# Dry run
flutter pub publish --dry-run

# Publish
flutter pub publish
````

#### **Step 4.3: Update netify_dio & netify_http Dependencies**

After `netify_core` is published, update dependencies in `netify_dio` and `netify_http`:

```yaml
dependencies:
  netify_core: ^3.0.0 # Use published version instead of path
```

#### **Step 4.4: Publish netify_dio**

```bash
cd packages/netify_dio

# Dry run
flutter pub publish --dry-run

# Publish
flutter pub publish
```

#### **Step 4.5: Publish netify_http**

```bash
cd packages/netify_http

# Dry run
flutter pub publish --dry-run

# Publish
flutter pub publish
```

---

### **Phase 5: Update Original Repository** 🔄

#### **Step 5.1: Archive ricoerlan/netify**

1. Go to https://github.com/ricoerlan/netify/settings
2. Scroll to "Danger Zone"
3. Click "Archive this repository"
4. Add archive message: "Moved to netify-app/netify-flutter"

#### **Step 5.2: Add Redirect README**

Update `ricoerlan/netify` README before archiving:

```markdown
# ⚠️ Repository Moved

This repository has been moved to the **netify-app** organization.

## New Location

**Repository**: [netify-app/netify-flutter](https://github.com/netify-app/netify-flutter)

## Packages

- `netify_core` - [pub.dev](https://pub.dev/packages/netify_core)
- `netify_dio` - [pub.dev](https://pub.dev/packages/netify_dio)
- `netify_http` - [pub.dev](https://pub.dev/packages/netify_http)

## Documentation

Visit [netify.dev](https://netify.dev) for documentation.

---

This repository is archived. All development continues at [netify-app/netify-flutter](https://github.com/netify-app/netify-flutter).
```

---

### **Phase 6: Announcement** 📢

#### **Step 6.1: Create Release**

Create v3.0.0 release on GitHub:

**Title**: "Netify v3.0.0 - Multi-Client Architecture"

**Body**:

```markdown
# 🎉 Netify v3.0.0 - Multi-Client Architecture

We're excited to announce Netify v3.0.0, featuring a complete architectural redesign to support multiple HTTP clients!

## 🆕 What's New

### Multi-Client Support

Netify now works with multiple HTTP clients through a modular adapter pattern:

- ✅ **netify_dio** - For Dio users
- ✅ **netify_http** - For http package users
- 📋 **netify_graphql** - Coming soon

### Zero Dependency Bloat

Each adapter is a separate package. Install only what you need!

## 📦 Packages

- **netify_core** v3.0.0 - [pub.dev](https://pub.dev/packages/netify_core)
- **netify_dio** v3.0.0 - [pub.dev](https://pub.dev/packages/netify_dio)
- **netify_http** v3.0.0 - [pub.dev](https://pub.dev/packages/netify_http)

## 🚀 Migration Guide

See [MIGRATION.md](MIGRATION.md) for upgrade instructions.

## 📚 Documentation

Visit [netify.dev](https://netify.dev) for complete documentation.

## 🙏 Thank You

Thank you to all contributors and users who made this release possible!
```

#### **Step 6.2: Social Media**

- Twitter/X announcement
- Reddit post (r/FlutterDev)
- Dev.to article
- Medium article

---

## ✅ Checklist

### **Pre-Migration**

- [x] Complete multi-client implementation
- [x] All packages pass flutter analyze
- [x] All tests passing
- [x] Documentation complete
- [x] CHANGELOG.md updated

### **Migration**

- [ ] Create netify-app/netify-flutter repository
- [ ] Push code to organization
- [ ] Update all pubspec.yaml files
- [ ] Update all documentation
- [ ] Create CONTRIBUTING.md
- [ ] Create root README.md

### **Publication**

- [ ] Publish netify_core to pub.dev
- [ ] Publish netify_dio to pub.dev
- [ ] Publish netify_http to pub.dev
- [ ] Verify packages on pub.dev

### **Cleanup**

- [ ] Archive ricoerlan/netify
- [ ] Add redirect README
- [ ] Update all external links

### **Announcement**

- [ ] Create GitHub release
- [ ] Twitter/X announcement
- [ ] Reddit post
- [ ] Blog article

---

## 📅 Timeline

**Day 1**: Create organization repository, push code  
**Day 2**: Update metadata, documentation  
**Day 3**: Publish to pub.dev  
**Day 4**: Archive old repository, announcements  
**Day 5**: Monitor feedback, fix issues

---

## 🆘 Rollback Plan

If issues arise during migration:

1. Keep `ricoerlan/netify` active (don't archive yet)
2. Unpublish packages from pub.dev if critical issues found
3. Fix issues in organization repository
4. Re-publish when ready

---

## 📞 Support

Questions about migration? Open a [Discussion](https://github.com/netify-app/netify-flutter/discussions).

---

**Last Updated**: December 23, 2025  
**Status**: Ready to Execute
