import 'constants.dart';

/// 环境配置
enum Environment { dev, prod }

class Env {
  Env._();

  static Environment current = Environment.dev;

  static String get baseUrl {
    switch (current) {
      case Environment.dev:
        return AppConstants.baseUrl;
      case Environment.prod:
        return AppConstants.baseUrl;
    }
  }

  static bool get isDev => current == Environment.dev;
  static bool get isProd => current == Environment.prod;
}
