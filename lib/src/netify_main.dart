import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'core/entities/netify_config.dart';
import 'core/entities/network_log.dart';
import 'core/repositories/log_repository.dart';
import 'data/interceptor/netify_interceptor.dart';
import 'data/repositories/log_repository_impl.dart';
import 'presentation/pages/netify_panel.dart';

class Netify {
  static LogRepository? _logRepository;
  static NetifyInterceptor? _interceptor;
  static NetifyConfig? _config;
  static Dio? _dio;
  static bool _isInitialized = false;

  Netify._();

  static Future<void> init({
    required Dio dio,
    NetifyConfig config = const NetifyConfig(),
  }) async {
    if (config.showOnlyInDebug && !kDebugMode) {
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

  static String exportAsJson() {
    final logsJson = logs.map((log) => log.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(logsJson);
  }

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
              .toList() ?? [],
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
              .toList() ?? [],
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

  static String generateCurl(NetworkLog log) {
    return log.toCurl();
  }

  static void clearLogs() {
    _logRepository?.clearLogs();
  }

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

  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const NetifyPanel(),
      ),
    );
  }

  static NetifyConfig? get config => _config;
}
