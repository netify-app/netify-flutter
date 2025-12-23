import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:netify_core/netify_core.dart';

/// Wrapper around http.Client that captures requests/responses
class NetifyHttpClient extends http.BaseClient {
  final http.Client client;
  final LogRepository repository;
  final NetifyConfig config;

  NetifyHttpClient({
    required this.client,
    required this.repository,
    required this.config,
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final logId = _generateId();
    final requestTime = DateTime.now();

    // Capture request
    final requestLog = NetworkLog(
      id: logId,
      method: request.method,
      url: request.url.toString(),
      requestHeaders: request.headers,
      requestBody: await _extractRequestBody(request),
      requestTime: requestTime,
    );

    // Check if request should be captured
    final shouldCapture =
        config.filters?.shouldCaptureRequest(requestLog) ?? true;

    if (shouldCapture) {
      repository.addLog(requestLog);

      try {
        config.callbacks?.onRequest?.call(requestLog);
      } catch (e) {
        // Silently ignore callback errors
      }
    }

    http.StreamedResponse? response;

    try {
      response = await client.send(request);

      // Read response body
      final responseBytes = await response.stream.toBytes();
      final responseBody = _decodeResponseBody(responseBytes, response.headers);

      // Create new response with the body we read
      final newResponse = http.StreamedResponse(
        http.ByteStream.fromBytes(responseBytes),
        response.statusCode,
        contentLength: response.contentLength,
        request: response.request,
        headers: response.headers,
        isRedirect: response.isRedirect,
        persistentConnection: response.persistentConnection,
        reasonPhrase: response.reasonPhrase,
      );

      if (shouldCapture) {
        final responseTime = DateTime.now();
        final updatedLog = requestLog.copyWith(
          statusCode: response.statusCode,
          statusMessage: response.reasonPhrase,
          responseHeaders: response.headers,
          responseBody: responseBody,
          responseSize: responseBytes.length,
          responseTime: responseTime,
          duration: responseTime.difference(requestTime),
        );

        final shouldCaptureResponse =
            config.filters?.shouldCapture(updatedLog) ?? true;

        if (shouldCaptureResponse) {
          repository.updateLog(updatedLog);

          try {
            config.callbacks?.onResponse?.call(updatedLog);
          } catch (e) {
            // Silently ignore callback errors
          }

          // Check for slow request
          if (config.filters?.captureSlowRequests != null &&
              updatedLog.duration != null) {
            if (updatedLog.duration! >= config.filters!.captureSlowRequests!) {
              try {
                config.callbacks?.onSlowRequest?.call(
                  updatedLog,
                  config.filters!.captureSlowRequests!,
                );
              } catch (e) {
                // Silently ignore callback errors
              }
            }
          }
        } else {
          repository.removeLog(logId);
        }
      }

      return newResponse;
    } catch (e) {
      if (shouldCapture) {
        final errorTime = DateTime.now();
        final errorLog = requestLog.copyWith(
          error: e.toString(),
          responseTime: errorTime,
          duration: errorTime.difference(requestTime),
        );

        final shouldCaptureError =
            config.filters?.shouldCapture(errorLog) ?? true;

        if (shouldCaptureError) {
          repository.updateLog(errorLog);

          try {
            config.callbacks?.onError?.call(errorLog);
          } catch (e) {
            // Silently ignore callback errors
          }
        } else {
          repository.removeLog(logId);
        }
      }

      rethrow;
    }
  }

  Future<dynamic> _extractRequestBody(http.BaseRequest request) async {
    if (request is http.Request) {
      final body = request.body;
      if (body.isEmpty) return null;

      try {
        return jsonDecode(body);
      } catch (e) {
        return body;
      }
    } else if (request is http.MultipartRequest) {
      return {
        'fields': request.fields,
        'files': request.files
            .map((f) => {
                  'field': f.field,
                  'filename': f.filename,
                  'length': f.length,
                })
            .toList(),
      };
    }
    return null;
  }

  dynamic _decodeResponseBody(List<int> bytes, Map<String, String> headers) {
    if (bytes.isEmpty) return null;

    final contentType = headers['content-type'] ?? '';

    try {
      final text = utf8.decode(bytes);

      if (contentType.contains('application/json')) {
        try {
          return jsonDecode(text);
        } catch (e) {
          return text;
        }
      }

      return text;
    } catch (e) {
      return '<binary data ${bytes.length} bytes>';
    }
  }

  String _generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
