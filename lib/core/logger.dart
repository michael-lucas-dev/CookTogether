import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    filter: ProductionFilter(),
  );

  static Future<Map<String, dynamic>> _getCommonMetadata() async {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'appVersion': _getAppVersion(),
      'deviceInfo': await _getDeviceInfo(),
      'platform': Platform.operatingSystem,
      'locale': Platform.localeName,
    };
  }

  static Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (e) {
      return 'unknown';
    }
  }

  static Future<Map<String, dynamic>> _getDeviceInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          'model': androidInfo.model,
          'manufacturer': androidInfo.manufacturer,
          'osVersion': androidInfo.version.release,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          'model': iosInfo.model,
          'name': iosInfo.name,
          'systemName': iosInfo.systemName,
          'systemVersion': iosInfo.systemVersion,
        };
      }
      return {};
    } catch (e) {
      return {'error': 'Failed to get device info'};
    }
  }

  static void logUserAction(String action, {Map<String, dynamic>? metadata}) async {
    final enrichedData = {
      ...await _getCommonMetadata(),
      'action': action,
      ...?metadata,
    };

    _logger.i('USER_ACTION: $action',error: enrichedData, time: DateTime.now());
  }

  static void logError(String message, dynamic error, StackTrace? stackTrace, {Map<String, dynamic>? metadata}) async {
    final errorData = {
      ...await _getCommonMetadata(),
      'message': message,
      'error': error.toString(),
      'stackTrace': stackTrace?.toString() ?? 'No stack trace',
      'errorType': error.runtimeType.toString(),
      ...?metadata,
    };

    _logger.e(message, error: error, stackTrace: stackTrace, time: DateTime.now());

    FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: message,
      information: errorData.entries,
    );
  }

  static void logPerformance(String operation, Duration duration, {Map<String, dynamic>? metadata}) async {
    final perfData = {
      ...await _getCommonMetadata(),
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'duration_s': duration.inSeconds,
      'duration': duration.toString(),
      ...?metadata,
    };

    _logger.d('PERFORMANCE: $operation took ${duration.inMilliseconds}ms',error: perfData, time: DateTime.now());
  }

  static void logAnalytics(String event, {Map<String, dynamic>? parameters}) async {
    final analyticsData = {
      ...await _getCommonMetadata(),
      'event': event,
      ...?parameters,
    };

    _logger.i('ANALYTICS: $event',error: analyticsData, time: DateTime.now());
  }

  static void logSecurity(String message, {Map<String, dynamic>? metadata}) async {
    final securityData = {
      ...await _getCommonMetadata(),
      'message': message,
      'timestamp': DateTime.now().toIso8601String(),
      ...?metadata,
    };

    _logger.w('SECURITY: $message',error: securityData, time: DateTime.now());
  }

  static void debug(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace, time: DateTime.now());
  }

  static void info(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace, time: DateTime.now());
  }

  static void warning(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace, time: DateTime.now());
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace, time: DateTime.now());
  }

  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace, time: DateTime.now());
  }
}
