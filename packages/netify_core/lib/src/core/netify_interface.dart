import 'package:flutter/material.dart';

import '../entities/network_log.dart';
import '../repositories/log_repository.dart';

/// Interface that adapters must implement to provide UI access
abstract class NetifyInterface {
  static NetifyInterface? _instance;

  static NetifyInterface get instance {
    if (_instance == null) {
      throw StateError(
          'Netify has not been initialized. Call NetifyDio.init() or similar first.');
    }
    return _instance!;
  }

  static void setInstance(NetifyInterface instance) {
    _instance = instance;
  }

  LogRepository get repository;
  GlobalKey<NavigatorState> get navigatorKey;

  Stream<List<NetworkLog>> get logsStream => repository.logsStream;
  List<NetworkLog> get logs => repository.logs;
  int get logCount => repository.logCount;

  List<NetworkLog> searchLogs(String query) => repository.searchLogs(query);

  Stream<Set<String>> get favoritesStream => repository.favoritesStream;
  Set<String> get favoriteIds => repository.favoriteIds;
  List<NetworkLog> get favoriteLogs => repository.favoriteLogs;

  void toggleFavorite(String logId) => repository.toggleFavorite(logId);
  bool isFavorite(String logId) => repository.isFavorite(logId);

  void clearLogs() => repository.clearLogs();

  Future<void> replayRequest(NetworkLog log);
  String exportAsJson();
  String exportAsHar();
  String generateCurl(NetworkLog log);
}

/// Convenience class for UI components to access Netify functionality
class Netify {
  static Stream<List<NetworkLog>> get logsStream =>
      NetifyInterface.instance.logsStream;
  static List<NetworkLog> get logs => NetifyInterface.instance.logs;
  static int get logCount => NetifyInterface.instance.logCount;

  static List<NetworkLog> searchLogs(String query) =>
      NetifyInterface.instance.searchLogs(query);

  static Stream<Set<String>> get favoritesStream =>
      NetifyInterface.instance.favoritesStream;
  static Set<String> get favoriteIds => NetifyInterface.instance.favoriteIds;
  static List<NetworkLog> get favoriteLogs =>
      NetifyInterface.instance.favoriteLogs;

  static void toggleFavorite(String logId) =>
      NetifyInterface.instance.toggleFavorite(logId);
  static bool isFavorite(String logId) =>
      NetifyInterface.instance.isFavorite(logId);

  static void clearLogs() => NetifyInterface.instance.clearLogs();

  static Future<void> replayRequest(NetworkLog log) =>
      NetifyInterface.instance.replayRequest(log);
  static String exportAsJson() => NetifyInterface.instance.exportAsJson();
  static String exportAsHar() => NetifyInterface.instance.exportAsHar();
  static String generateCurl(NetworkLog log) =>
      NetifyInterface.instance.generateCurl(log);

  static GlobalKey<NavigatorState> get navigatorKey =>
      NetifyInterface.instance.navigatorKey;
}
