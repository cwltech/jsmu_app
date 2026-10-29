import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    filter: ProductionFilter(),
    printer: PrettyPrinter(
      methodCount: 1,
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      _logger.i(message);
    }
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  // Network sanitized logging helper
  static void logApiRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) {
    if (kDebugMode) {
      _logger.i(
        '🌐 API REQUEST: [$method] $endpoint ${queryParams != null ? 'params: $queryParams' : ''}',
      );
    }
  }

  static void logApiResponse({
    required String endpoint,
    required int statusCode,
    dynamic data,
  }) {
    if (kDebugMode) {
      if (statusCode >= 200 && statusCode < 300) {
        _logger.i('✅ API SUCCESS [$statusCode]: $endpoint');
      } else {
        _logger.w('⚠️ API FAILED [$statusCode]: $endpoint -> $data');
      }
    }
  }
}
