/// Example demonstrating netify_dio usage with Dio HTTP client
library;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netify_dio/netify_dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Dio
  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  ));

  // Initialize Netify with Dio
  await NetifyDio.init(
    dio: dio,
    config: NetifyConfig(
      entryMode: NetifyEntryMode.bubble,
      callbacks: NetifyCallbacks(
        onRequest: (log) => debugPrint('📤 Request: ${log.method} ${log.url}'),
        onResponse: (log) => debugPrint('📥 Response: ${log.statusCode}'),
        onError: (log) => debugPrint('❌ Error: ${log.error}'),
      ),
    ),
  );

  runApp(const NetifyDioExample());
}

class NetifyDioExample extends StatelessWidget {
  const NetifyDioExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Netify Dio Example',
      navigatorKey: NetifyDio.navigatorKey, // Required for bubble UI
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
  final dio = Dio(BaseOptions(
    baseUrl: 'https://jsonplaceholder.typicode.com',
  ));

  bool _loading = false;
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Netify Dio Example'),
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
      final response = await dio.get('/posts');
      setState(() {
        _result = 'Fetched ${response.data.length} posts';
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
      final response = await dio.get('/posts/1');
      setState(() {
        _result = 'Title: ${response.data['title']}';
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
      final response = await dio.post(
        '/posts',
        data: {
          'title': 'Test Post',
          'body': 'This is a test post created via Netify example',
          'userId': 1,
        },
      );
      setState(() {
        _result = 'Created post with ID: ${response.data['id']}';
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
      final response = await dio.put(
        '/posts/1',
        data: {
          'title': 'Updated Post',
          'body': 'This post was updated',
          'userId': 1,
        },
      );
      setState(() {
        _result = 'Updated post: ${response.data['title']}';
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
      await dio.delete('/posts/1');
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
      await dio.get('/posts/999999');
      setState(() {
        _result = 'Unexpected success';
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
