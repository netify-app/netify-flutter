import '../entities/network_log.dart';

/// Filters configuration for Netify.
///
/// Use this to control which network requests are captured and stored.
/// This is useful for reducing noise, focusing on specific types of requests,
/// or optimizing memory usage.
///
/// Example:
/// ```dart
/// NetifyFilters(
///   // Only capture error responses
///   captureStatusCodes: [400, 401, 403, 404, 500, 502, 503],
///
///   // Only capture slow requests
///   captureSlowRequests: Duration(seconds: 3),
///
///   // Ignore health check endpoints
///   ignorePaths: ['/health', '/metrics', '/ping'],
///
///   // Ignore analytics domains
///   ignoreHosts: ['analytics.google.com', 'firebase.google.com'],
/// )
/// ```
class NetifyFilters {
  /// Creates a filters configuration.
  const NetifyFilters({
    this.captureStatusCodes,
    this.captureSlowRequests,
    this.ignorePaths,
    this.ignoreHosts,
  });

  /// Only capture requests with these HTTP status codes.
  ///
  /// If specified, only requests with status codes in this list will be
  /// captured and stored. This is useful for focusing on errors or specific
  /// response types.
  ///
  /// Example:
  /// ```dart
  /// // Only capture client and server errors
  /// captureStatusCodes: [400, 401, 403, 404, 500, 502, 503]
  /// ```
  final List<int>? captureStatusCodes;

  /// Capture requests that take longer than this duration.
  ///
  /// If specified, only requests that exceed this duration will be captured.
  /// This is useful for identifying performance issues. Also triggers the
  /// [NetifyCallbacks.onSlowRequest] callback.
  ///
  /// Example:
  /// ```dart
  /// // Only capture requests slower than 3 seconds
  /// captureSlowRequests: Duration(seconds: 3)
  /// ```
  final Duration? captureSlowRequests;

  /// Ignore requests to these URL paths.
  ///
  /// Requests with URLs containing any of these path segments will be ignored.
  /// This is useful for filtering out health checks, metrics endpoints, or
  /// other noise.
  ///
  /// Example:
  /// ```dart
  /// ignorePaths: ['/health', '/metrics', '/ping']
  /// ```
  final List<String>? ignorePaths;

  /// Ignore requests to these hosts.
  ///
  /// Requests to these host domains will be ignored. This is useful for
  /// filtering out analytics, tracking, or third-party services.
  ///
  /// Example:
  /// ```dart
  /// ignoreHosts: ['analytics.google.com', 'firebase.google.com']
  /// ```
  final List<String>? ignoreHosts;

  /// Determines if a log should be captured based on the configured filters.
  ///
  /// Returns `true` if the log passes all filter criteria and should be
  /// captured, `false` otherwise.
  bool shouldCapture(NetworkLog log) {
    // Check ignored hosts first (most common filter)
    if (ignoreHosts != null && ignoreHosts!.isNotEmpty) {
      try {
        final uri = Uri.parse(log.url);
        if (ignoreHosts!.contains(uri.host)) {
          return false;
        }
      } catch (_) {
        // Invalid URL, let it through
      }
    }

    // Check ignored paths
    if (ignorePaths != null && ignorePaths!.isNotEmpty) {
      try {
        final uri = Uri.parse(log.url);
        if (ignorePaths!.any((path) => uri.path.contains(path))) {
          return false;
        }
      } catch (_) {
        // Invalid URL, let it through
      }
    }

    // Check status codes (only applies to completed requests)
    if (captureStatusCodes != null &&
        captureStatusCodes!.isNotEmpty &&
        log.statusCode != null) {
      if (!captureStatusCodes!.contains(log.statusCode)) {
        return false;
      }
    }

    // Check slow requests (only applies to completed requests)
    if (captureSlowRequests != null && log.duration != null) {
      if (log.duration! < captureSlowRequests!) {
        return false;
      }
    }

    return true;
  }

  /// Determines if a log should be captured at the request stage.
  ///
  /// This is called when a request is first made, before any response.
  /// Only checks filters that can be applied at request time (hosts, paths).
  bool shouldCaptureRequest(NetworkLog log) {
    // Check ignored hosts
    if (ignoreHosts != null && ignoreHosts!.isNotEmpty) {
      try {
        final uri = Uri.parse(log.url);
        if (ignoreHosts!.contains(uri.host)) {
          return false;
        }
      } catch (_) {
        // Invalid URL, let it through
      }
    }

    // Check ignored paths
    if (ignorePaths != null && ignorePaths!.isNotEmpty) {
      try {
        final uri = Uri.parse(log.url);
        if (ignorePaths!.any((path) => uri.path.contains(path))) {
          return false;
        }
      } catch (_) {
        // Invalid URL, let it through
      }
    }

    return true;
  }
}
