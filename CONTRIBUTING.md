# Contributing to Netify

Thank you for your interest in contributing to Netify! We welcome contributions from the community.

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK (>=3.0.0)
- Git

### Development Setup

```bash
# Clone the repository
git clone https://github.com/netify-app/netify-flutter.git
cd netify-flutter

# Install melos for monorepo management
dart pub global activate melos

# Bootstrap all packages (install dependencies)
melos bootstrap

# Run tests across all packages
melos test

# Run analysis across all packages
melos analyze

# Format code
melos format
```

## 📝 How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/netify-app/netify-flutter/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Flutter/Dart version
   - Package version
   - Code samples if applicable

### Suggesting Features

1. Check [Discussions](https://github.com/netify-app/netify-flutter/discussions) for similar ideas
2. Create a new discussion in the "Ideas" category
3. Describe the feature and its use case
4. Wait for community feedback before implementing

### Submitting Pull Requests

1. **Fork the repository**
2. **Create a feature branch** from `main`

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**

   - Follow the code style guidelines
   - Add tests for new features
   - Update documentation

4. **Test your changes**

   ```bash
   melos test
   melos analyze
   ```

5. **Commit your changes**

   ```bash
   git commit -m "feat: add amazing feature"
   ```

   Follow [Conventional Commits](https://www.conventionalcommits.org/)

6. **Push to your fork**

   ```bash
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Provide a clear description
   - Reference related issues
   - Wait for review

## 📐 Code Style

### Dart Code Style

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart)
- Use `dart format` to format code
- Run `flutter analyze` before committing
- Maintain 80%+ test coverage for new code

### Commit Messages

We use [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Examples:

```
feat: add GraphQL adapter support
fix: resolve memory leak in log repository
docs: update README with new examples
```

## 🧪 Testing

### Running Tests

```bash
# Test all packages
melos test

# Test specific package
cd packages/netify_core
flutter test

# Test with coverage
melos test --coverage
```

### Writing Tests

- Write unit tests for all new features
- Write widget tests for UI components
- Aim for 80%+ code coverage
- Use descriptive test names

Example:

```dart
test('should capture request when filter allows', () {
  // Arrange
  final log = NetworkLog(...);
  final filter = NetifyFilters(captureStatusCodes: [200]);

  // Act
  final result = filter.shouldCapture(log);

  // Assert
  expect(result, isTrue);
});
```

## 📚 Documentation

### Code Documentation

- Add dartdoc comments for public APIs
- Include examples in documentation
- Document parameters and return values

Example:

````dart
/// Captures a network request and adds it to the log repository.
///
/// The request will only be captured if it passes the configured filters.
///
/// Example:
/// ```dart
/// adapter.captureRequest(NetworkLog(
///   method: 'GET',
///   url: 'https://api.example.com/users',
/// ));
/// ```
///
/// See also:
/// * [NetifyFilters] for filtering configuration
void captureRequest(NetworkLog log) {
  // Implementation
}
````

### README Updates

- Update package README when adding features
- Add examples for new functionality
- Keep documentation in sync with code

## 🏗️ Project Structure

```
netify-flutter/
├── packages/
│   ├── netify_core/      # Core functionality
│   ├── netify_dio/       # Dio adapter
│   ├── netify_http/      # HTTP adapter
│   └── netify_graphql/   # GraphQL adapter (future)
├── examples/             # Example apps
├── docs/                 # Documentation
├── melos.yaml           # Monorepo configuration
└── README.md            # Main README
```

## 🔍 Code Review Process

1. **Automated Checks**

   - CI runs tests and analysis
   - All checks must pass

2. **Maintainer Review**

   - Code quality
   - Test coverage
   - Documentation
   - Breaking changes

3. **Feedback & Iteration**

   - Address review comments
   - Update PR as needed

4. **Merge**
   - Squash and merge
   - Update CHANGELOG
   - Tag release if needed

## 📦 Publishing Packages

Only maintainers can publish packages to pub.dev.

### Pre-publish Checklist

- [ ] All tests passing
- [ ] Analysis passing
- [ ] CHANGELOG updated
- [ ] Version bumped in pubspec.yaml
- [ ] Documentation updated
- [ ] Examples working

### Publishing

```bash
cd packages/netify_core
flutter pub publish --dry-run
flutter pub publish
```

## 🎯 Areas for Contribution

### High Priority

- [ ] GraphQL adapter implementation
- [ ] Additional HTTP client adapters
- [ ] Performance optimizations
- [ ] Documentation improvements

### Medium Priority

- [ ] Example apps for each adapter
- [ ] Integration tests
- [ ] UI/UX improvements
- [ ] Accessibility enhancements

### Low Priority

- [ ] Additional export formats
- [ ] Custom themes
- [ ] Localization
- [ ] Browser extension (future)

## 💬 Communication

- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: Questions, ideas, and general discussion
- **Discord**: Real-time chat (coming soon)
- **Email**: hello@netify.dev

## 📜 Code of Conduct

Please be respectful and constructive in all interactions. We follow the [Contributor Covenant Code of Conduct](https://www.contributor-covenant.org/).

## ❓ Questions?

- Check the [FAQ](docs/faq.md)
- Search [Discussions](https://github.com/netify-app/netify-flutter/discussions)
- Ask in [Discord](https://discord.gg/netify) (coming soon)
- Email: hello@netify.dev

## 🙏 Thank You!

Your contributions make Netify better for everyone. We appreciate your time and effort!

---

**Happy Contributing!** 🎉
