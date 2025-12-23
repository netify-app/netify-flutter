# Netify

> **Universal Network Inspector for Mobile & Web**

See every network request in your app. Works across Flutter, React Native, iOS, Android, and Web. Beautiful UI, zero setup, production-ready.

---

## 🌟 What is Netify?

Netify is the **only network debugging tool** that works across all platforms with a unified experience. It's like Chrome DevTools, but for mobile apps—and it works everywhere.

### **Why Netify?**

- 🌍 **Universal** - One tool for Flutter, React Native, iOS, Android, Web
- 🎨 **Beautiful** - Modern UI with dark mode
- ⚡ **Zero Setup** - 2-line integration, no proxy needed
- 🔄 **Dual Mode** - Debug UI + Production monitoring
- 🪶 **Lightweight** - Minimal overhead, maximum insight

---

## 📦 Platform SDKs

### **Flutter** ✅ Available Now

```yaml
dependencies:
  netify_dio: ^3.0.0 # For Dio users
  netify_http: ^3.0.0 # For http package users
```

```dart
import 'package:netify_dio/netify_dio.dart';

await NetifyDio.init(dio: dio);
```

**Repository**: [netify-flutter](https://github.com/netify-app/netify-flutter)  
**Documentation**: [netify.dev/docs/flutter](https://netify.dev/docs/flutter)

---

### **React Native** 📋 Coming Q2 2025

```bash
npm install @netify/react-native
```

```typescript
import Netify from "@netify/react-native";

Netify.init({ interceptor: "axios" });
```

**Repository**: [netify-react-native](https://github.com/netify-app/netify-react-native) (planned)

---

### **iOS** 📋 Coming Q3 2025

```swift
import Netify

Netify.shared.initialize()
```

**Repository**: [netify-ios](https://github.com/netify-app/netify-ios) (planned)

---

### **Android** 📋 Coming Q3 2025

```kotlin
Netify.initialize(this)
```

**Repository**: [netify-android](https://github.com/netify-app/netify-android) (planned)

---

### **Web** 📋 Coming Q4 2025

```typescript
import { Netify } from "@netify/web";

Netify.init({ interceptor: "fetch" });
```

**Repository**: [netify-web](https://github.com/netify-app/netify-web) (planned)

---

## 🎯 Features

### **Debug Mode** (Development)

- 📡 **Network Inspection** - Capture all HTTP requests/responses
- 🫧 **Floating Bubble** - Draggable overlay with request count
- 🌙 **Dark Mode** - Beautiful UI in light and dark themes
- 📸 **Share as Image** - Export request details as images
- 🔄 **Request Replay** - Re-send any captured request
- 🔍 **Search & Filter** - Find requests quickly
- ⭐ **Favorites** - Mark important requests
- 📤 **Export** - JSON, HAR, cURL formats

### **Production Mode** (Optional)

- 📊 **Monitoring** - Lightweight request tracking
- 🔌 **Integrations** - Sentry, Firebase, Datadog, custom webhooks
- 🎯 **Smart Filters** - Capture only what matters
- 🔒 **Privacy** - PII detection and redaction
- ⚡ **Zero Overhead** - Minimal performance impact

---

## 🚀 Roadmap

### **Phase 1: Flutter** (Q1 2025) ✅

- ✅ Multi-client architecture (Dio, http, GraphQL)
- ✅ Core debugging features
- ✅ Production callbacks & filters
- 🚀 Launch netify.dev website

### **Phase 2: React Native** (Q2 2025)

- 📱 React Native SDK
- 🔌 Official integrations (Sentry, Firebase)
- 📚 Expanded documentation

### **Phase 3: Native Platforms** (Q3 2025)

- 🍎 iOS SDK (Swift)
- 🤖 Android SDK (Kotlin)
- 🌍 Cross-platform examples

### **Phase 4: Web & Cloud** (Q4 2025)

- 🌐 Web SDK + Browser Extension
- ☁️ Netify Cloud (SaaS)
- 💰 Monetization launch

---

## 🏢 Organization

### **Active Repositories**

- **[netify-flutter](https://github.com/netify-app/netify-flutter)** - Flutter SDK (v3.0.0)
- **[netify-website](https://github.com/netify-app/netify-website)** - netify.dev (planned)

### **Planned Repositories**

- **netify-react-native** - React Native SDK (Q2 2025)
- **netify-ios** - Native iOS SDK (Q3 2025)
- **netify-android** - Native Android SDK (Q3 2025)
- **netify-web** - Web SDK (Q4 2025)
- **netify-cloud** - Cloud backend (Q4 2025)
- **netify-integrations** - Official integrations

---

## 📚 Documentation

- **Website**: [netify.dev](https://netify.dev) (coming soon)
- **Docs**: [netify.dev/docs](https://netify.dev/docs) (coming soon)
- **Blog**: [netify.dev/blog](https://netify.dev/blog) (coming soon)

### **Quick Links**

- [Getting Started](https://github.com/netify-app/netify-flutter#getting-started)
- [API Reference](https://github.com/netify-app/netify-flutter/blob/main/docs/API.md)
- [Examples](https://github.com/netify-app/netify-flutter/tree/main/examples)
- [Contributing](https://github.com/netify-app/.github/blob/main/CONTRIBUTING.md)

---

## 🤝 Contributing

We welcome contributions! Whether it's:

- 🐛 Bug reports
- 💡 Feature requests
- 📝 Documentation improvements
- 🔧 Code contributions
- 🌍 Translations

See our [Contributing Guide](https://github.com/netify-app/.github/blob/main/CONTRIBUTING.md) to get started.

---

## 💬 Community

- **GitHub Discussions**: [Ask questions, share ideas](https://github.com/orgs/netify-app/discussions)
- **Discord**: [Join our community](https://discord.gg/netify) (coming soon)
- **Twitter**: [@netify_dev](https://twitter.com/netify_dev) (coming soon)

---

## 📊 Stats

![GitHub Stars](https://img.shields.io/github/stars/netify-app?style=social)
![Total Downloads](https://img.shields.io/badge/downloads-100K+-blue)
![Platforms](https://img.shields.io/badge/platforms-5-green)

---

## 📄 License

All Netify SDKs are open source and released under the **MIT License**.

See [LICENSE](LICENSE) for details.

---

## 🙏 Acknowledgments

Built with ❤️ by [@ricoerlan](https://github.com/ricoerlan) and [contributors](https://github.com/orgs/netify-app/people).

Inspired by:

- Chrome DevTools
- Alice (Flutter)
- Chucker (Android)
- Netfox (iOS)
- Reactotron (React Native)

---

## 🔗 Links

- **Organization**: https://github.com/netify-app
- **Website**: https://netify.dev (coming soon)
- **Email**: hello@netify.dev
- **Sponsor**: [GitHub Sponsors](https://github.com/sponsors/ricoerlan) (coming soon)

---

<div align="center">

**[⭐ Star us on GitHub](https://github.com/netify-app/netify-flutter)** • **[📖 Read the Docs](https://netify.dev)** • **[💬 Join Discord](https://discord.gg/netify)**

Made with ❤️ for developers everywhere

</div>
