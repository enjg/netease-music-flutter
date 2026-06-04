/// 路由配置 - 控制TabBar和迷你播放器显示
class RouteConfig {
  /// 是否显示TabBar
  final bool showTabBar;

  /// 是否显示迷你播放器
  final bool showMiniPlayer;

  const RouteConfig({
    this.showTabBar = false,
    this.showMiniPlayer = false,
  });
}

/// 各页面的路由配置
class RouteConfigs {
  RouteConfigs._();

  // TabBar页面 - 显示TabBar + 迷你播放器
  static const tabBarPage = RouteConfig(showTabBar: true, showMiniPlayer: true);

  // 二级页面 - 只显示迷你播放器
  static const subPage = RouteConfig(showTabBar: false, showMiniPlayer: true);

  // 全屏页面 - 什么都不显示
  static const fullScreen = RouteConfig(showTabBar: false, showMiniPlayer: false);

  /// 根据路由名获取配置
  static RouteConfig of(String route) {
    // TabBar页面
    const tabBarRoutes = {'/main'};
    // 全屏页面 (播放器/登录/启动)
    const fullScreenRoutes = {'/player', '/login', '/splash'};

    if (tabBarRoutes.contains(route)) return tabBarPage;
    if (fullScreenRoutes.contains(route)) return fullScreen;
    return subPage; // 默认: 二级页面
  }
}
