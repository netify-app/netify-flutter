import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:netify_core/netify_core.dart';

class NetifyDioImpl implements NetifyInterface {
  @override
  final LogRepository repository;

  final Dio dio;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  NetifyDioImpl(this.repository, this.dio, this.navigatorKey);

  @override
  Stream<List<NetworkLog>> get logsStream => repository.logsStream;

  @override
  List<NetworkLog> get logs => repository.logs;

  @override
  int get logCount => repository.logCount;

  @override
  List<NetworkLog> searchLogs(String query) => repository.searchLogs(query);

  @override
  Stream<Set<String>> get favoritesStream => repository.favoritesStream;

  @override
  Set<String> get favoriteIds => repository.favoriteIds;

  @override
  List<NetworkLog> get favoriteLogs => repository.favoriteLogs;

  @override
  void toggleFavorite(String logId) => repository.toggleFavorite(logId);

  @override
  bool isFavorite(String logId) => repository.isFavorite(logId);

  @override
  void clearLogs() => repository.clearLogs();

  @override
  Future<void> replayRequest(NetworkLog log) async {
    try {
      await dio.request(
        log.url,
        data: log.requestBody,
        options: Options(
          method: log.method,
          headers: log.requestHeaders,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  String exportAsJson() {
    final logsJson = repository.logs.map((log) => log.toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(logsJson);
  }

  @override
  String exportAsHar() {
    final entries = repository.logs.map((log) {
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
          'version': '3.0.0',
        },
        'entries': entries,
      },
    };

    return const JsonEncoder.withIndent('  ').convert(har);
  }

  @override
  String generateCurl(NetworkLog log) {
    return log.toCurl();
  }
}
