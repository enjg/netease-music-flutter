/// 全局常量
class AppConstants {
  AppConstants._();

  // API
  static const String baseUrl = 'http://124.156.194.16:3000';
  static const int connectTimeout = 10000;  // 10s
  static const int receiveTimeout = 15000;  // 15s

  // 存储Key
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyTheme = 'theme_mode';
  static const String keyPlayerState = 'player_state';
  static const String keySearchHistory = 'search_history';

  // 分页
  static const int pageSize = 20;
  static const int pageSizeSmall = 10;

  // 播放器
  static const int defaultDuration = 240; // 默认时长 4分钟

  // 动画时长
  static const Duration animFast = Duration(milliseconds: 150);
  static const Duration animNormal = Duration(milliseconds: 300);
  static const Duration animSlow = Duration(milliseconds: 500);
}
