import 'package:flutter/foundation.dart';
import 'package:netify/netify.dart';
// import 'package:sentry_flutter/sentry_flutter.dart';

/// Integration helper for Sentry error tracking.
///
/// This class provides pre-configured callbacks to send network errors
/// and slow requests to Sentry for monitoring.
///
/// Usage:
/// ```dart
/// await Netify.init(
///   dio: dio,
///   config: NetifyConfig(
///     callbacks: SentryIntegration.createCallbacks(
///       captureFailedRequests: true,
///       captureSlowRequests: Duration(seconds: 3),
///     ),
///   ),
/// );
/// ```
class SentryIntegration {
  /// Creates Netify callbacks configured for Sentry integration.
  ///
  /// Set [captureFailedRequests] to true to send failed network requests
  /// to Sentry as exceptions.
  ///
  /// Set [captureSlowRequests] to a duration threshold to send slow
  /// requests to Sentry as warning messages.
  static NetifyCallbacks createCallbacks({
    bool captureFailedRequests = true,
    Duration? captureSlowRequests,
  }) {
    return NetifyCallbacks(
      onError: captureFailedRequests
          ? (log) {
              // Uncomment when using Sentry:
              // Sentry.captureException(
              //   Exception('Network request failed: ${log.url}'),
              //   stackTrace: StackTrace.current,
              //   hint: Hint.withMap({
              //     'url': log.url,
              //     'method': log.method,
              //     'statusCode': log.statusCode,
              //     'duration': log.duration?.inMilliseconds,
              //     'error': log.error,
              //   }),
              // );

              // For demo purposes:
              debugPrint(
                  '[Sentry] Network error: ${log.method} ${log.url} - ${log.statusCode}');
            }
          : null,
      onSlowRequest: captureSlowRequests != null
          ? (log, threshold) {
              // Uncomment when using Sentry:
              // Sentry.captureMessage(
              //   'Slow network request: ${log.url}',
              //   level: SentryLevel.warning,
              //   hint: Hint.withMap({
              //     'url': log.url,
              //     'method': log.method,
              //     'duration': log.duration?.inMilliseconds,
              //     'threshold': threshold.inMilliseconds,
              //   }),
              // );

              // For demo purposes:
              debugPrint(
                  '[Sentry] Slow request: ${log.method} ${log.url} - ${log.duration?.inMilliseconds}ms (threshold: ${threshold.inMilliseconds}ms)');
            }
          : null,
    );
  }
}
