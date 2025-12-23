/// Netify - A lightweight, debug-only network inspector for Flutter apps.
///
/// This library provides network inspection capabilities for Flutter apps
/// using Dio HTTP client. Features include request/response logging,
/// favorites, dark mode, search, export, share as image, callbacks for
/// integrations, and filters for controlling what gets captured.
library netify;

export 'src/core/callbacks/netify_callbacks.dart';
export 'src/core/entities/network_log.dart';
export 'src/core/entities/netify_config.dart';
export 'src/core/filters/netify_filters.dart';
export 'src/netify_main.dart';
export 'src/presentation/pages/log_detail_page.dart';
export 'src/presentation/pages/netify_panel.dart';
