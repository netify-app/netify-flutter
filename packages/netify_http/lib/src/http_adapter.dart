import 'package:http/http.dart' as http;
import 'package:netify_core/netify_core.dart';

import 'netify_http_client.dart';

class NetifyHttpAdapter extends NetifyAdapter {
  final http.Client originalClient;
  NetifyHttpClient? _wrappedClient;

  NetifyHttpAdapter({
    required this.originalClient,
    required super.repository,
    required super.config,
  });

  @override
  void attach() {
    _wrappedClient = NetifyHttpClient(
      client: originalClient,
      repository: repository,
      config: config,
    );
  }

  @override
  void detach() {
    _wrappedClient?.close();
    _wrappedClient = null;
  }

  /// Get the wrapped client to use for requests
  http.Client get client => _wrappedClient ?? originalClient;
}
