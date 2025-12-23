import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:netify_core/netify_core.dart';

import 'http_adapter.dart';
import 'netify_http_impl.dart';

class NetifyHttp {
  static NetifyHttpAdapter? _adapter;
  static bool _isInitialized = false;

  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Initialize Netify with an http.Client
  static Future<void> init({
    required http.Client client,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) return;
    if (_isInitialized) return;

    final repository = LogRepositoryImpl(config: config);
    _adapter = NetifyHttpAdapter(
      originalClient: client,
      repository: repository,
      config: config,
    );

    _adapter!.attach();

    // Set the NetifyInterface instance for UI components
    final impl = NetifyHttpImpl(repository, _adapter!.client, navigatorKey);
    NetifyInterface.setInstance(impl);

    _isInitialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBubble();
    });
  }

  static void _showBubble() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = navigatorKey.currentState;
      if (state == null) {
        Future.delayed(const Duration(milliseconds: 100), _showBubble);
        return;
      }

      final overlay = state.overlay;
      if (overlay == null) {
        Future.delayed(const Duration(milliseconds: 100), _showBubble);
        return;
      }

      final bubbleOverlay = OverlayEntry(
        builder: (context) => NetifyBubble(
          onTap: () => show(context),
          logsStream: Netify.logsStream,
          initialLogs: Netify.logs,
        ),
      );

      overlay.insert(bubbleOverlay);
    });
  }

  /// Get the wrapped client to use for making requests
  static http.Client get client {
    if (_adapter == null) {
      throw StateError(
          'NetifyHttp has not been initialized. Call NetifyHttp.init() first.');
    }
    return _adapter!.client;
  }

  // Convenience getters that delegate to Netify class
  static Stream<List<NetworkLog>> get logsStream => Netify.logsStream;
  static List<NetworkLog> get logs => Netify.logs;
  static int get logCount => Netify.logCount;
  static List<NetworkLog> searchLogs(String query) => Netify.searchLogs(query);
  static Stream<Set<String>> get favoritesStream => Netify.favoritesStream;
  static Set<String> get favoriteIds => Netify.favoriteIds;
  static List<NetworkLog> get favoriteLogs => Netify.favoriteLogs;
  static void toggleFavorite(String logId) => Netify.toggleFavorite(logId);
  static bool isFavorite(String logId) => Netify.isFavorite(logId);
  static void clearLogs() => Netify.clearLogs();
  static String exportAsJson() => Netify.exportAsJson();
  static String exportAsHar() => Netify.exportAsHar();
  static String generateCurl(NetworkLog log) => Netify.generateCurl(log);
  static Future<void> replayRequest(NetworkLog log) =>
      Netify.replayRequest(log);

  static Future<void> dispose() async {
    _adapter?.detach();
    _adapter = null;
    _isInitialized = false;
  }

  static void show(BuildContext context) {
    final navigator = Navigator.maybeOf(context, rootNavigator: true);
    if (navigator != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (_) => const NetifyPanel(),
        ),
      );
    }
  }
}
