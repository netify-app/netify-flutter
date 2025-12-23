/// Example demonstrating netify_core usage
///
/// This shows how to use the core Netify functionality.
/// For real-world usage, use netify_dio or netify_http adapters.
library;

import 'package:flutter/material.dart';
import 'package:netify_core/netify_core.dart';

void main() {
  runApp(const NetifyCoreExample());
}

class NetifyCoreExample extends StatelessWidget {
  const NetifyCoreExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netify Core Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Netify Core Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.network_check,
              size: 100,
              color: Colors.blue,
            ),
            const SizedBox(height: 24),
            const Text(
              'Netify Core',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'This package provides core functionality for Netify.\n\n'
                'For real-world usage, install one of the adapters:',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            _buildAdapterCard(
              'netify_dio',
              'For Dio HTTP client',
              'https://pub.dev/packages/netify_dio',
            ),
            const SizedBox(height: 12),
            _buildAdapterCard(
              'netify_http',
              'For dart:io http package',
              'https://pub.dev/packages/netify_http',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdapterCard(String name, String description, String url) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(description),
          ],
        ),
      ),
    );
  }
}
