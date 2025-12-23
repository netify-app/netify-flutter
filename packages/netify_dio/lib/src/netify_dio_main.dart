import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netify_core/netify_core.dart';

import 'dio_adapter.dart';
import 'netify_dio_impl.dart';

class NetifyDio {
  static NetifyDioAdapter? _adapter;
  static bool _isInitialized = false;

  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> init({
    required Dio dio,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) return;
    if (_isInitialized) return;

    final repository = LogRepositoryImpl(config: config);
    _adapter = NetifyDioAdapter(
      dio: dio,
      repository: repository,
      config: config,
    );

    _adapter!.attach();

    // Set the NetifyInterface instance for UI components
    final impl = NetifyDioImpl(repository, dio, navigatorKey);
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
