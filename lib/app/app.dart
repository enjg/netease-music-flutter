import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/widgets/global_tab_bar.dart';
import '../../shared/widgets/global_mini_player.dart';
import 'routes.dart';
import 'route_config.dart';

/// 路由状态Controller - 监听路由变化
class RouteStateController extends GetxController {
  final currentRoute = '/splash'.obs;
  final config = const RouteConfig().obs;

  void updateRoute(String route) {
    // 延迟到下一帧更新，避免在 build 阶段调用 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentRoute.value = route;
      config.value = RouteConfigs.of(route);
    });
  }
}

/// 应用根Widget
class NetEaseMusicApp extends StatelessWidget {
  const NetEaseMusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeState = Get.put(RouteStateController());

    return GetMaterialApp(
      title: '网易云音乐',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
      ),
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
      routingCallback: (routing) {
        if (routing != null) {
          routeState.updateRoute(routing.current ?? '/splash');
        }
      },
      builder: (context, child) {
        return _GlobalOverlay(child: child ?? const SizedBox.shrink());
      },
    );
  }
}

/// 全局浮层包装器
/// TabBar 和迷你播放器是浮于内容之上的液态玻璃，页面内容全屏延伸，
/// 各页面内部自行添加底部留白（如 SliverToBoxAdapter + SizedBox）让内容可滚动到浮层后面。
class _GlobalOverlay extends StatelessWidget {
  final Widget child;
  const _GlobalOverlay({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 页面内容 - 全屏延伸，不加底部 padding
          Positioned.fill(child: child),
          // 迷你播放器
          const GlobalMiniPlayer(),
          // TabBar
          const GlobalTabBar(),
        ],
      ),
    );
  }
}
