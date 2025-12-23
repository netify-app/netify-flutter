import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:netify/netify.dart';

/// Integration helper for custom webhook notifications.
///
/// This class provides pre-configured callbacks to send network events
/// to a custom webhook endpoint.
///
/// Usage:
/// ```dart
/// await Netify.init(
///   dio: dio,
///   config: NetifyConfig(
///     callbacks: WebhookIntegration('https://your-webhook.com/netify').createCallbacks(),
///   ),
/// );
/// ```
class WebhookIntegration {
  final String webhookUrl;
  final Dio _dio = Dio();

  /// Creates a webhook integration with the specified URL.
  WebhookIntegration(this.webhookUrl);

  /// Creates Netify callbacks configured for webhook integration.
  NetifyCallbacks createCallbacks() {
    return NetifyCallbacks(
      onError: (log) async {
        try {
          await _dio.post(webhookUrl, data: {
            'type': 'error',
            'url': log.url,
            'method': log.method,
            'statusCode': log.statusCode,
            'error': log.error,
            'timestamp': log.requestTime.toIso8601String(),
          });
          debugPrint('[Webhook] Error sent to $webhookUrl');
        } catch (e) {
          // Silently ignore webhook errors to not break the app
          debugPrint('[Webhook] Failed to send error: $e');
        }
      },
      onSlowRequest: (log, threshold) async {
        try {
          await _dio.post(webhookUrl, data: {
            'type': 'slow_request',
            'url': log.url,
            'method': log.method,
            'duration': log.duration?.inMilliseconds,
            'threshold': threshold.inMilliseconds,
            'timestamp': log.requestTime.toIso8601String(),
          });
          debugPrint('[Webhook] Slow request sent to $webhookUrl');
        } catch (e) {
          // Silently ignore webhook errors
          debugPrint('[Webhook] Failed to send slow request: $e');
        }
      },
    );
  }
}
