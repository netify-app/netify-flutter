import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'core/entities/netify_config.dart';
import 'core/entities/network_log.dart';
import 'core/repositories/log_repository.dart';
import 'data/interceptor/netify_interceptor.dart';
import 'data/repositories/log_repository_impl.dart';
import 'presentation/pages/netify_panel.dart';
import 'presentation/widgets/netify_bubble.dart';

/// Netify - A lightweight, debug-only network inspector for Flutter apps.
///
/// This class provides the main API for initializing and interacting with Netify.
/// It captures HTTP requests/responses via Dio interceptor and provides methods
/// to access, search, export, and manage network logs.
///
/// Example:
/// ```dart
/// await Netify.init(dio: dio);
/// ```
class Netify {
  static LogRepository? _logRepository;
  static NetifyInterceptor? _interceptor;
  static NetifyConfig? _config;
  static Dio? _dio;
  static bool _isInitialized = false;
  static OverlayEntry? _bubbleOverlay;

  Netify._();

  /// Global navigator key - pass this to MaterialApp.navigatorKey
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// Initializes Netify with the given Dio instance and optional configuration.
  ///
  /// Must be called before using any other Netify methods.
  ///
  /// Set [enable] to false to disable Netify (useful for production).
  /// Don't forget to add `navigatorKey: Netify.navigatorKey` to your MaterialApp!
  static Future<void> init({
    required Dio dio,
    bool enable = true,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (!enable) {
      return;
    }

    if (_isInitialized) {
      return;
    }

    _config = config;
    _dio = dio;

    _logRepository = LogRepositoryImpl(config: config);
    _interceptor = NetifyInterceptor(logRepository: _logRepository!);

    dio.interceptors.add(_interceptor!);

    _isInitialized = true;

    // Show bubble after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showBubble();
    });
  }

  static void _showBubble() {
    if (_bubbleOverlay != null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = navigatorKey.currentState;
      if (state == null) {
        debugPrint('Netify: navigatorKey.currentState is null, retrying...');
        // Retry after next frame
        Future.delayed(const Duration(milliseconds: 100), _showBubble);
        return;
      }

      final overlay = state.overlay;
      if (overlay == null) {
        debugPrint('Netify: Navigator overlay is null, retrying...');
        // Retry after next frame
        Future.delayed(const Duration(milliseconds: 100), _showBubble);
        return;
      }

      debugPrint('Netify: Creating bubble overlay');
      _bubbleOverlay = OverlayEntry(
        builder: (context) => NetifyBubble(
          onTap: () => _openPanel(),
        ),
      );

      overlay.insert(_bubbleOverlay!);
      debugPrint('Netify: Bubble overlay inserted successfully');
    });
  }

  static void _openPanel() {
    final context = navigatorKey.currentContext;
    if (context != null) {
      // Hide bubble when opening panel
      _bubbleOverlay?.remove();

      Navigator.of(context)
          .push(
        MaterialPageRoute(builder: (_) => const NetifyPanel()),
      )
          .then((_) {
        // Show bubble again when panel is closed
        if (_bubbleOverlay != null) {
          final state = navigatorKey.currentState;
          state?.overlay?.insert(_bubbleOverlay!);
        }
      });
    }
  }

  /// Hides the floating bubble
  static void hideBubble() {
    _bubbleOverlay?.remove();
    _bubbleOverlay = null;
  }

  /// Stream of network logs that updates when new logs are added.
  static Stream<List<NetworkLog>> get logsStream {
    return _logRepository?.logsStream ?? const Stream.empty();
  }

  /// Returns the current list of all captured network logs.
  static List<NetworkLog> get logs {
    return _logRepository?.logs ?? [];
  }

  /// Returns the total number of captured network logs.
  static int get logCount {
    return _logRepository?.logCount ?? 0;
  }

  /// Searches logs by URL, method, or status code.
  static List<NetworkLog> searchLogs(String query) {
    return _logRepository?.searchLogs(query) ?? [];
  }

  /// Stream of favorite log IDs that updates when favorites change.
  static Stream<Set<String>> get favoritesStream {
    return _logRepository?.favoritesStream ?? const Stream.empty();
  }

  /// Returns the current set of favorite log IDs.
  static Set<String> get favoriteIds {
    return _logRepository?.favoriteIds ?? {};
  }

  /// Returns the list of favorited network logs.
  static List<NetworkLog> get favoriteLogs {
    return _logRepository?.favoriteLogs ?? [];
  }

  /// Toggles the favorite status of a log by its ID.
  static void toggleFavorite(String logId) {
    _logRepository?.toggleFavorite(logId);
  }

  /// Checks if a log is marked as favorite.
  static bool isFavorite(String logId) {
    return _logRepository?.isFavorite(logId) ?? false;
  }

  /// Exports all network logs as a formatted JSON string.
  static String exportAsJson() {
    final logsJson = logs.map((log) => log.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(logsJson);
  }

  /// Exports all network logs in HAR (HTTP Archive) format.
  static String exportAsHar() {
    final entries = logs.map((log) {
      return {
        'startedDateTime': log.requestTime.toIso8601String(),
        'time': log.duration?.inMilliseconds ?? 0,
        'request': {
          'method': log.method,
          'url': log.url,
          'headers': log.requestHeaders?.entries
                  .map((e) => {'name': e.key, 'value': e.value.toString()})
                  .toList() ??
              [],
          'postData': log.requestBody != null
              ? {
                  'mimeType': 'application/json',
                  'text': log.requestBody is String
                      ? log.requestBody
                      : jsonEncode(log.requestBody),
                }
              : null,
        },
        'response': {
          'status': log.statusCode ?? 0,
          'statusText': log.statusMessage ?? '',
          'headers': log.responseHeaders?.entries
                  .map((e) => {'name': e.key, 'value': e.value.toString()})
                  .toList() ??
              [],
          'content': {
            'size': log.responseSize ?? 0,
            'mimeType': 'application/json',
            'text': log.responseBody is String
                ? log.responseBody
                : jsonEncode(log.responseBody ?? ''),
          },
        },
        'timings': {
          'wait': log.duration?.inMilliseconds ?? 0,
          'receive': 0,
        },
      };
    }).toList();

    final har = {
      'log': {
        'version': '1.2',
        'creator': {
          'name': 'Netify',
          'version': '1.0.0',
        },
        'entries': entries,
      },
    };

    return const JsonEncoder.withIndent('  ').convert(har);
  }

  /// Exports all network logs as CSV format.
  static String exportAsCsv() {
    final buffer = StringBuffer();
    buffer.writeln('Method,URL,Status,Duration(ms),Size(bytes),Timestamp');

    for (final log in logs) {
      final url = log.url.replaceAll(',', '%2C');
      buffer.writeln(
        '${log.method},$url,${log.statusCode ?? ""},${log.duration?.inMilliseconds ?? ""},${log.responseSize ?? ""},${log.requestTime.toIso8601String()}',
      );
    }

    return buffer.toString();
  }

  /// Generates a cURL command for the given network log.
  static String generateCurl(NetworkLog log) {
    return log.toCurl();
  }

  /// Clears all captured network logs.
  static void clearLogs() {
    _logRepository?.clearLogs();
  }

  /// Replays a network request using the original parameters.
  static Future<void> replayRequest(NetworkLog log) async {
    if (_dio == null) return;

    try {
      await _dio!.request(
        log.url,
        data: log.requestBody,
        options: Options(
          method: log.method,
          headers: log.requestHeaders,
        ),
      );
    } catch (e) {
      // Errors will be caught by the interceptor and logged as well
      debugPrint('Netify: Error replay request: $e');
      rethrow;
    }
  }

  /// Disposes Netify and cleans up resources.
  static Future<void> dispose() async {
    if (_dio != null && _interceptor != null) {
      _dio!.interceptors.remove(_interceptor);
    }

    _logRepository?.dispose();

    _logRepository = null;
    _interceptor = null;
    _dio = null;
    _isInitialized = false;
  }

  /// Shows the Netify panel as a new route.
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

  /// Returns the current Netify configuration.
  static NetifyConfig? get config => _config;
}
