/// Dio HTTP client configuration with interceptors.
library;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/app_constants.dart';

/// Creates and configures a [Dio] instance for the application.
///
/// In debug mode a [LogInterceptor] is added for request/response logging.
Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: kBaseUrl,
      connectTimeout: kConnectTimeout,
      receiveTimeout: kReceiveTimeout,
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        // ignore: avoid_print
        logPrint: (obj) => debugPrint('[Dio] ${obj.toString()}'),
      ),
    );
  }

  return dio;
}
