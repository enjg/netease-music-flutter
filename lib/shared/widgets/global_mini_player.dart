import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_dimensions.dart';
import '../../app/route_config.dart';
import '../../app/app.dart';
import '../../shared/services/player_service.dart';
import '../../app/routes.dart';

/// 全局迷你播放器浮层 - 单实例
class GlobalMiniPlayer extends StatelessWidget {
  const GlobalMiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!Get.isRegistered<RouteStateController>()) return const SizedBox.shrink();
      final routeState = Get.find<RouteStateController>();
      final config = routeState.config.value;
      if (!config.showMiniPlayer) return const SizedBox.shrink();

      if (!Get.isRegistered<PlayerService>()) return const SizedBox.shrink();
      final player = Get.find<PlayerService>();
      final song = player.currentSong.value;
      if (song == null) return const SizedBox.shrink();

      final bottomPadding = config.showTabBar
          ? AppDimensions.bottomNavHeight + 14 + MediaQuery.of(context).padding.bottom
          : 12 + MediaQuery.of(context).padding.bottom;

      // Positioned 在 Obx 内部返回，但 Stack 的 children 允许非 Positioned widget
      // 用 Align + Padding 代替 Positioned 来避免约束问题
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding, left: 10, right: 10),
          child: GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.player),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusXxl),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 30, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // 封面
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 44, height: 44, color: AppColors.surface,
                          child: song.coverUrl.isNotEmpty
                              ? Image.network('${song.coverUrl}?param=88x88', fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: AppColors.textTertiary))
                              : const Icon(Icons.music_note, color: AppColors.textTertiary),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // 歌曲信息
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(song.artistText, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      // 播放/暂停
                      GestureDetector(
                        onTap: player.togglePlay,
                        child: Obx(() => Icon(
                          player.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 28, color: AppColors.textPrimary,
                        )),
                      ),
                      const SizedBox(width: 8),
                      // 下一首
                      GestureDetector(
                        onTap: player.next,
                        child: const Icon(Icons.skip_next_rounded, size: 24, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
