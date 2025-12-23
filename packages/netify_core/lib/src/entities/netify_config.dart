import '../callbacks/netify_callbacks.dart';
import '../filters/netify_filters.dart';

/// Entry mode for accessing Netify panel
enum NetifyEntryMode {
  /// Draggable floating bubble showing request count (default)
  bubble,

  /// No automatic entry point, use Netify.show() manually
  none,
}

/// Configuration options for Netify.
///
/// Use this to customize Netify behavior such as max logs, entry point,
/// callbacks for integrations, and filters for controlling what gets captured.
///
/// Example:
/// ```dart
/// NetifyConfig(
///   maxLogs: 1000,
///   entryMode: NetifyEntryMode.bubble,
///   callbacks: NetifyCallbacks(
///     onError: (log) => Sentry.captureException(...),
///   ),
///   filters: NetifyFilters(
///     captureStatusCodes: [400, 401, 403, 404, 500],
///     ignorePaths: ['/health'],
///   ),
/// )
/// ```
class NetifyConfig {
  /// Maximum number of logs to keep in memory. Defaults to 500.
  final int maxLogs;

  /// Entry point mode for accessing Netify panel.
  final NetifyEntryMode entryMode;

  /// Callbacks for integrating with external monitoring services.
  ///
  /// Use this to send network data to Sentry, Firebase, or custom analytics.
  final NetifyCallbacks? callbacks;

  /// Filters for controlling which requests are captured.
  ///
  /// Use this to reduce noise, focus on errors, or ignore specific endpoints.
  final NetifyFilters? filters;

  const NetifyConfig({
    this.maxLogs = 500,
    this.entryMode = NetifyEntryMode.bubble,
    this.callbacks,
    this.filters,
  });

  NetifyConfig copyWith({
    int? maxLogs,
    NetifyEntryMode? entryMode,
    NetifyCallbacks? callbacks,
    NetifyFilters? filters,
  }) {
    return NetifyConfig(
      maxLogs: maxLogs ?? this.maxLogs,
      entryMode: entryMode ?? this.entryMode,
      callbacks: callbacks ?? this.callbacks,
      filters: filters ?? this.filters,
    );
  }
}
