import '../entities/network_log.dart';

/// Callback triggered when a request is sent.
///
/// This is called immediately after a request is initiated, before any
/// response is received. Use this to track outgoing requests or send
/// request data to external monitoring services.
///
/// Example:
/// ```dart
/// onRequest: (log) {
///   print('Request sent: ${log.method} ${log.url}');
/// }
/// ```
typedef OnRequestCallback = void Function(NetworkLog log);

/// Callback triggered when a response is received.
///
/// This is called after a successful response is received from the server.
/// The [log] contains complete request and response information including
/// status code, headers, body, and timing data.
///
/// Example:
/// ```dart
/// onResponse: (log) {
///   print('Response received: ${log.statusCode} in ${log.duration}ms');
/// }
/// ```
typedef OnResponseCallback = void Function(NetworkLog log);

/// Callback triggered when a request fails.
///
/// This is called when a request fails due to network errors, timeouts,
/// or HTTP error status codes (4xx, 5xx). The [log] contains error
/// information and any partial response data if available.
///
/// Example:
/// ```dart
/// onError: (log) {
///   print('Request failed: ${log.url} - ${log.error}');
/// }
/// ```
typedef OnErrorCallback = void Function(NetworkLog log);

/// Callback triggered when a request exceeds a duration threshold.
///
/// This is called when a request takes longer than the configured threshold
/// in [NetifyFilters.captureSlowRequests]. Use this to track performance
/// issues or send alerts for slow API calls.
///
/// Example:
/// ```dart
/// onSlowRequest: (log, threshold) {
///   print('Slow request: ${log.url} took ${log.duration}ms (threshold: ${threshold.inMilliseconds}ms)');
/// }
/// ```
typedef OnSlowRequestCallback = void Function(
  NetworkLog log,
  Duration threshold,
);

/// Callbacks configuration for Netify.
///
/// Use this to integrate Netify with external monitoring services like
/// Sentry, Firebase Performance, or custom analytics platforms.
///
/// Example:
/// ```dart
/// NetifyCallbacks(
///   onError: (log) {
///     // Send to Sentry
///     Sentry.captureException(
///       Exception('Network request failed: ${log.url}'),
///       hint: Hint.withMap({'statusCode': log.statusCode}),
///     );
///   },
///   onSlowRequest: (log, threshold) {
///     // Track slow requests
///     analytics.logEvent('slow_request', {
///       'url': log.url,
///       'duration': log.duration?.inMilliseconds,
///     });
///   },
/// )
/// ```
class NetifyCallbacks {
  /// Creates a callbacks configuration.
  const NetifyCallbacks({
    this.onRequest,
    this.onResponse,
    this.onError,
    this.onSlowRequest,
  });

  /// Called when a request is sent.
  final OnRequestCallback? onRequest;

  /// Called when a response is received successfully.
  final OnResponseCallback? onResponse;

  /// Called when a request fails.
  final OnErrorCallback? onError;

  /// Called when a request exceeds the slow request threshold.
  final OnSlowRequestCallback? onSlowRequest;
}
