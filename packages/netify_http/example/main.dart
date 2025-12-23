/// Example demonstrating netify_http usage with http package
library;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:netify_http/netify_http.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize http client
  final client = http.Client();

  // Initialize Netify with http client
  await NetifyHttp.init(
    client: client,
    config: NetifyConfig(
      entryMode: NetifyEntryMode.bubble,
      callbacks: NetifyCallbacks(
        onRequest: (log) => debugPrint('📤 Request: ${log.method} ${log.url}'),
        onResponse: (log) => debugPrint('📥 Response: ${log.statusCode}'),
        onError: (log) => debugPrint('❌ Error: ${log.error}'),
      ),
    ),
  );

  runApp(const NetifyHttpExample());
}

class NetifyHttpExample extends StatelessWidget {
  const NetifyHttpExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netify HTTP Example',
      navigatorKey: NetifyHttp.navigatorKey, // Required for bubble UI
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatefulWidget {
  const ExampleHomePage({super.key});

  @override
  State<ExampleHomePage> createState() => _ExampleHomePageState();
}

class _ExampleHomePageState extends State<ExampleHomePage> {
  final baseUrl = 'https://jsonplaceholder.typicode.com';
  bool _loading = false;
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Netify HTTP Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Tap the buttons below to make API calls.\n'
              'Watch the Netify bubble to see captured requests!',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loading ? null : _fetchPosts,
              icon: const Icon(Icons.list),
              label: const Text('GET /posts'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _fetchPost,
              icon: const Icon(Icons.article),
              label: const Text('GET /posts/1'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _createPost,
              icon: const Icon(Icons.add),
              label: const Text('POST /posts'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _updatePost,
              icon: const Icon(Icons.edit),
              label: const Text('PUT /posts/1'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _deletePost,
              icon: const Icon(Icons.delete),
              label: const Text('DELETE /posts/1'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _loading ? null : _triggerError,
              icon: const Icon(Icons.error),
              label: const Text('Trigger 404 Error'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_result.isNotEmpty)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Response:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(_result),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final response = await NetifyHttp.client.get(
        Uri.parse('$baseUrl/posts'),
      );
      final posts = jsonDecode(response.body) as List;
      setState(() {
        _result = 'Fetched ${posts.length} posts';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _fetchPost() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final response = await NetifyHttp.client.get(
        Uri.parse('$baseUrl/posts/1'),
      );
      final post = jsonDecode(response.body);
      setState(() {
        _result = 'Title: ${post['title']}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _createPost() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final response = await NetifyHttp.client.post(
        Uri.parse('$baseUrl/posts'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': 'Test Post',
          'body': 'This is a test post created via Netify example',
          'userId': 1,
        }),
      );
      final post = jsonDecode(response.body);
      setState(() {
        _result = 'Created post with ID: ${post['id']}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _updatePost() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final response = await NetifyHttp.client.put(
        Uri.parse('$baseUrl/posts/1'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': 'Updated Post',
          'body': 'This post was updated',
          'userId': 1,
        }),
      );
      final post = jsonDecode(response.body);
      setState(() {
        _result = 'Updated post: ${post['title']}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _deletePost() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      await NetifyHttp.client.delete(
        Uri.parse('$baseUrl/posts/1'),
      );
      setState(() {
        _result = 'Post deleted successfully';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _triggerError() async {
    setState(() {
      _loading = true;
      _result = '';
    });

    try {
      final response = await NetifyHttp.client.get(
        Uri.parse('$baseUrl/posts/999999'),
      );
      setState(() {
        _result = 'Status: ${response.statusCode}';
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _result = 'Error triggered: $e';
        _loading = false;
      });
    }
  }
}
