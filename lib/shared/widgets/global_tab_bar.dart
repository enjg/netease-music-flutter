import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../app/route_config.dart';
import '../../app/app.dart';
import '../../modules/main/main_controller.dart';

/// 全局TabBar浮层 - 单实例
class GlobalTabBar extends StatelessWidget {
  const GlobalTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!Get.isRegistered<RouteStateController>()) return const SizedBox.shrink();
      final routeState = Get.find<RouteStateController>();
      final config = routeState.config.value;
      if (!config.showTabBar) return const SizedBox.shrink();

      if (!Get.isRegistered<MainController>()) return const SizedBox.shrink();
      final controller = Get.find<MainController>();

      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom + 6,
            left: 10,
            right: 10,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(
                height: AppDimensions.bottomNavHeight,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.65),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
                  border: Border.all(color: AppColors.glassBorder, width: 0.5),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, offset: const Offset(0, -4)),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(controller.tabs.length, (i) {
                    final tab = controller.tabs[i];
                    final isActive = controller.currentIndex.value == i;
                    return GestureDetector(
                      onTap: () => controller.changePage(i),
                      behavior: HitTestBehavior.opaque,
                      child: SizedBox(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              tab['icon'] as IconData,
                              size: 24,
                              color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tab['label'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                                color: isActive ? AppColors.textPrimary : AppColors.textTertiary,
                              ),
                            ),
                            if (isActive)
                              Container(
                                margin: const EdgeInsets.only(top: 2),
                                width: 16, height: 2,
                                decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(1)),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
