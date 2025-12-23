import '../entities/netify_config.dart';
import '../entities/network_log.dart';
import '../repositories/log_repository.dart';

abstract class NetifyAdapter {
  final LogRepository repository;
  final NetifyConfig config;

  NetifyAdapter({
    required this.repository,
    required this.config,
  });

  void attach();

  void detach();

  void captureRequest(NetworkLog log) {
    if (config.filters?.shouldCaptureRequest(log) ?? true) {
      repository.addLog(log);

      try {
        config.callbacks?.onRequest?.call(log);
      } catch (e) {
        // Silently ignore callback errors
      }
    }
  }

  void captureResponse(NetworkLog log) {
    final shouldCapture = config.filters?.shouldCapture(log) ?? true;

    if (shouldCapture) {
      repository.updateLog(log);

      try {
        config.callbacks?.onResponse?.call(log);
      } catch (e) {
        // Silently ignore callback errors
      }

      if (config.filters?.captureSlowRequests != null && log.duration != null) {
        if (log.duration! >= config.filters!.captureSlowRequests!) {
          try {
            config.callbacks?.onSlowRequest?.call(
              log,
              config.filters!.captureSlowRequests!,
            );
          } catch (e) {
            // Silently ignore callback errors
          }
        }
      }
    } else {
      repository.removeLog(log.id);
    }
  }

  void captureError(NetworkLog log) {
    final shouldCapture = config.filters?.shouldCapture(log) ?? true;

    if (shouldCapture) {
      repository.updateLog(log);

      try {
        config.callbacks?.onError?.call(log);
      } catch (e) {
        // Silently ignore callback errors
      }

      if (config.filters?.captureSlowRequests != null && log.duration != null) {
        if (log.duration! >= config.filters!.captureSlowRequests!) {
          try {
            config.callbacks?.onSlowRequest?.call(
              log,
              config.filters!.captureSlowRequests!,
            );
          } catch (e) {
            // Silently ignore callback errors
          }
        }
      }
    } else {
      repository.removeLog(log.id);
    }
  }

  String generateId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }
}
