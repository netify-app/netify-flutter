/// Entry mode for accessing Netify panel
enum NetifyEntryMode {
  /// Draggable floating bubble showing request count (default)
  bubble,

  /// No automatic entry point, use Netify.show() manually
  none,
}

/// Configuration options for Netify.
///
/// Use this to customize Netify behavior such as max logs and entry point.
class NetifyConfig {
  /// Maximum number of logs to keep in memory. Defaults to 500.
  final int maxLogs;

  /// Entry point mode for accessing Netify panel.
  final NetifyEntryMode entryMode;

  const NetifyConfig({
    this.maxLogs = 500,
    this.entryMode = NetifyEntryMode.bubble,
  });

  NetifyConfig copyWith({
    int? maxLogs,
    NetifyEntryMode? entryMode,
  }) {
    return NetifyConfig(
      maxLogs: maxLogs ?? this.maxLogs,
      entryMode: entryMode ?? this.entryMode,
    );
  }
}
