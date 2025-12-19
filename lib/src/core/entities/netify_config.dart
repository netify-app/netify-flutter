/// Entry mode for accessing Netify panel
enum NetifyEntryMode {
  /// Draggable floating bubble showing request count (default)
  bubble,
  
  /// No automatic entry point, use Netify.show() manually
  none,
}

class NetifyConfig {
  final int maxLogs;
  final bool showOnlyInDebug;
  final NetifyEntryMode entryMode;

  const NetifyConfig({
    this.maxLogs = 500,
    this.showOnlyInDebug = true,
    this.entryMode = NetifyEntryMode.bubble,
  });

  NetifyConfig copyWith({
    int? maxLogs,
    bool? showOnlyInDebug,
    NetifyEntryMode? entryMode,
  }) {
    return NetifyConfig(
      maxLogs: maxLogs ?? this.maxLogs,
      showOnlyInDebug: showOnlyInDebug ?? this.showOnlyInDebug,
      entryMode: entryMode ?? this.entryMode,
    );
  }
}
