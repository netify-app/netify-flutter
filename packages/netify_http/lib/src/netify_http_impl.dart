import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:netify_core/netify_core.dart';

class NetifyHttpImpl implements NetifyInterface {
  @override
  final LogRepository repository;

  final http.Client client;

  @override
  final GlobalKey<NavigatorState> navigatorKey;

  NetifyHttpImpl(this.repository, this.client, this.navigatorKey);

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
      final uri = Uri.parse(log.url);
      final headers = _convertHeaders(log.requestHeaders);

      switch (log.method.toUpperCase()) {
        case 'GET':
          await client.get(uri, headers: headers);
          break;
        case 'POST':
          await client.post(
            uri,
            headers: headers,
            body: _encodeBody(log.requestBody),
          );
          break;
        case 'PUT':
          await client.put(
            uri,
            headers: headers,
            body: _encodeBody(log.requestBody),
          );
          break;
        case 'PATCH':
          await client.patch(
            uri,
            headers: headers,
            body: _encodeBody(log.requestBody),
          );
          break;
        case 'DELETE':
          await client.delete(uri, headers: headers);
          break;
        default:
          throw UnsupportedError('Method ${log.method} not supported');
      }
    } catch (e) {
      rethrow;
    }
  }

  Map<String, String>? _convertHeaders(Map<String, dynamic>? headers) {
    if (headers == null) return null;
    return headers.map((key, value) => MapEntry(key, value.toString()));
  }

  dynamic _encodeBody(dynamic body) {
    if (body == null) return null;
    if (body is String) return body;
    return jsonEncode(body);
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
