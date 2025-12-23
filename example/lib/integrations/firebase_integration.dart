import 'package:flutter/foundation.dart';
import 'package:netify/netify.dart';
// import 'package:firebase_performance/firebase_performance.dart';

/// Integration helper for Firebase Performance Monitoring.
///
/// This class provides pre-configured callbacks to send network metrics
/// to Firebase Performance for monitoring.
///
/// Usage:
/// ```dart
/// await Netify.init(
///   dio: dio,
///   config: NetifyConfig(
///     callbacks: FirebaseIntegration.createCallbacks(),
///   ),
/// );
/// ```
class FirebaseIntegration {
  // static final _metrics = <String, HttpMetric>{};

  /// Creates Netify callbacks configured for Firebase Performance integration.
  static NetifyCallbacks createCallbacks() {
    return NetifyCallbacks(
      onRequest: (log) {
        // Uncomment when using Firebase Performance:
        // final metric = FirebasePerformance.instance.newHttpMetric(
        //   log.url,
        //   HttpMethod.values.firstWhere(
        //     (m) => m.name.toUpperCase() == log.method,
        //     orElse: () => HttpMethod.Get,
        //   ),
        // );
        // metric.start();
        // _metrics[log.id] = metric;

        // For demo purposes:
        debugPrint('[Firebase] Request started: ${log.method} ${log.url}');
      },
      onResponse: (log) {
        // Uncomment when using Firebase Performance:
        // final metric = _metrics.remove(log.id);
        // if (metric != null && log.statusCode != null) {
        //   metric.httpResponseCode = log.statusCode!;
        //   if (log.responseSize != null) {
        //     metric.responsePayloadSize = log.responseSize!;
        //   }
        //   metric.stop();
        // }

        // For demo purposes:
        debugPrint(
            '[Firebase] Response received: ${log.method} ${log.url} - ${log.statusCode} (${log.duration?.inMilliseconds}ms)');
      },
      onError: (log) {
        // Uncomment when using Firebase Performance:
        // final metric = _metrics.remove(log.id);
        // metric?.stop();

        // For demo purposes:
        debugPrint('[Firebase] Request failed: ${log.method} ${log.url}');
      },
    );
  }
}
