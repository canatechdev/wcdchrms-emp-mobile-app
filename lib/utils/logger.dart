import 'dart:developer' as dev;

class AppLogger {
  static void log(String message, {String name = 'APP'}) {
    dev.log(message, name: name, time: DateTime.now());
  }

  static void info(String message) => log('ℹ️ INFO: $message', name: 'INFO');
  static void success(String message) => log('✅ SUCCESS: $message', name: 'SUCCESS');
  static void error(String message, [Object? error, StackTrace? stack]) {
    dev.log(
      '❌ ERROR: $message',
      name: 'ERROR',
      error: error,
      stackTrace: stack,
      time: DateTime.now(),
    );
  }

  static void request(String url, dynamic data) {
    log('🚀 REQUEST: $url\nData: $data', name: 'NETWORK');
  }

  static void response(String url, dynamic response) {
    log('📥 RESPONSE: $url\nResult: $response', name: 'NETWORK');
  }
}
