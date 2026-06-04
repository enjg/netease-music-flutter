import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
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
class _GlobalOverlay extends StatelessWidget {
  final Widget child;
  const _GlobalOverlay({required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // 页面内容 - 用 Padding 包裹，通过 Obx 只监听 padding 变化
          Positioned.fill(
            child: Obx(() {
              if (!Get.isRegistered<RouteStateController>()) {
                return Padding(padding: EdgeInsets.zero, child: child);
              }
              final routeState = Get.find<RouteStateController>();
              final bottomPadding = _calcBottomPadding(context, routeState.config.value);
              return Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: child,
              );
            }),
          ),
          // 迷你播放器
          const GlobalMiniPlayer(),
          // TabBar
          const GlobalTabBar(),
        ],
      ),
    );
  }

  double _calcBottomPadding(BuildContext context, RouteConfig config) {
    double padding = MediaQuery.of(context).padding.bottom;
    if (config.showTabBar) padding += AppDimensions.bottomNavHeight + 6;
    if (config.showMiniPlayer) padding += 64 + 8;
    return padding;
  }
}
