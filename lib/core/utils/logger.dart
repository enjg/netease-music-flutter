import 'package:logger/logger.dart';

/// 全局日志工具
class Log {
  Log._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 80,
      noBoxingByDefault: true,
    ),
  );

  static void d(String message) => _logger.d(message);
  static void i(String message) => _logger.i(message);
  static void w(String message) => _logger.w(message);
  static void e(String message, [dynamic error, StackTrace? stack]) =>
      _logger.e(message, error: error, stackTrace: stack);
}
