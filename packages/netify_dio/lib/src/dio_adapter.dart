import 'package:dio/dio.dart';
import 'package:netify_core/netify_core.dart';

import 'netify_interceptor.dart';

class NetifyDioAdapter extends NetifyAdapter {
  final Dio dio;
  late final NetifyInterceptor _interceptor;

  NetifyDioAdapter({
    required this.dio,
    required super.repository,
    required super.config,
  });

  @override
  void attach() {
    _interceptor = NetifyInterceptor(
      logRepository: repository,
      config: config,
    );
    dio.interceptors.add(_interceptor);
  }

  @override
  void detach() {
    dio.interceptors.remove(_interceptor);
  }
}
