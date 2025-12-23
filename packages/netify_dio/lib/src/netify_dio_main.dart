import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netify_core/netify_core.dart';

import 'dio_adapter.dart';

class NetifyDio {
  static NetifyDioAdapter? _adapter;
  static LogRepository? _logRepository;
  static bool _isInitialized = false;

  static final navigatorKey = GlobalKey<NavigatorState>();

  static Future<void> init({
    required Dio dio,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) return;
    if (_isInitialized) return;

    _logRepository = LogRepositoryImpl(config: config);
    _adapter = NetifyDioAdapter(
      dio: dio,
      repository: _logRepository!,
      config: config,
    );

    _adapter!.attach();
    _isInitialized = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBubble();
    });
  }

  static void _showBubble() {
    // Bubble logic will be handled by netify_core
  }

  static Stream<List<NetworkLog>> get logsStream {
    return _logRepository?.logsStream ?? const Stream.empty();
  }

  static List<NetworkLog> get logs {
    return _logRepository?.logs ?? [];
  }

  static int get logCount {
    return _logRepository?.logCount ?? 0;
  }

  static List<NetworkLog> searchLogs(String query) {
    return _logRepository?.searchLogs(query) ?? [];
  }

  static Stream<Set<String>> get favoritesStream {
    return _logRepository?.favoritesStream ?? const Stream.empty();
  }

  static Set<String> get favoriteIds {
    return _logRepository?.favoriteIds ?? {};
  }

  static List<NetworkLog> get favoriteLogs {
    return _logRepository?.favoriteLogs ?? [];
  }

  static void toggleFavorite(String logId) {
    _logRepository?.toggleFavorite(logId);
  }

  static bool isFavorite(String logId) {
    return _logRepository?.isFavorite(logId) ?? false;
  }

  static void clearLogs() {
    _logRepository?.clearLogs();
  }

  static Future<void> dispose() async {
    _adapter?.detach();
    _logRepository?.dispose();
    _adapter = null;
    _logRepository = null;
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
