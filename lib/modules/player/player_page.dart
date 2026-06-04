import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../shared/services/player_service.dart';
import 'player_controller.dart';

class PlayerPage extends GetView<PlayerController> {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final song = controller.playerService.currentSong.value;
        if (song == null) {
          return const Center(child: Text('暂无播放', style: TextStyle(color: AppColors.textTertiary)));
        }
        return Stack(
          children: [
            // 背景渐变
            Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 0.8,
                  colors: [Color(0xFF1a0a2e), Color(0xFF0a0a0a)],
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                  // 顶部导航
                  _buildTopBar(),
                  const Spacer(),

                  // 黑胶唱片
                  _buildVinylDisc(song.coverUrl),

                  const Spacer(),

                  // 歌曲信息
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.name, style: AppTextStyles.h3, maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Text(song.artistText, style: AppTextStyles.bodySmall),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border_rounded, color: AppColors.textSecondary),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 进度条
                  _buildProgressBar(),
                  const SizedBox(height: 24),

                  // 控制按钮
                  _buildControls(),
                  const SizedBox(height: 32),

                  // 底部操作
                  _buildBottomBar(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 32, color: AppColors.textPrimary),
            onPressed: () => Get.back(),
          ),
          const Spacer(),
          Column(
            children: [
              Text('正在播放', style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary)),
              Obx(() => Text(
                '${controller.playerService.currentIndex.value + 1}/${controller.playerService.playlist.length}',
                style: AppTextStyles.caption,
              )),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildVinylDisc(String coverUrl) {
    return Obx(() {
      final isPlaying = controller.playerService.isPlaying.value;
      return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: isPlaying ? 2 * pi : 0),
        duration: const Duration(seconds: 20),
        builder: (_, double angle, __) {
          return Transform.rotate(
            angle: angle,
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF1A1A1A),
                border: Border.all(color: const Color(0xFF333333), width: 2),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 40, offset: const Offset(0, 10)),
                ],
              ),
              child: Center(
                child: ClipOval(
                  child: Container(
                    width: 160, height: 160,
                    color: AppColors.surface,
                    child: coverUrl.isNotEmpty
                        ? Image.network('$coverUrl?param=320x320', fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.album, size: 60, color: AppColors.textTertiary))
                        : const Icon(Icons.album, size: 60, color: AppColors.textTertiary),
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Obx(() {
        final p = controller.playerService;
        return Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                activeTrackColor: AppColors.accent,
                inactiveTrackColor: AppColors.textTertiary.withOpacity(0.2),
                thumbColor: Colors.white,
                overlayColor: AppColors.accent.withOpacity(0.1),
              ),
              child: Slider(
                value: p.progress.value.clamp(0, 1),
                onChanged: controller.seek,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(Formatters.duration(p.currentTime.value), style: AppTextStyles.caption),
                  Text(Formatters.duration(p.duration.value), style: AppTextStyles.caption),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Obx(() {
        final p = controller.playerService;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(_playModeIcon(p.playMode.value), color: AppColors.textSecondary, size: 24),
              onPressed: controller.toggleMode,
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded, color: AppColors.textPrimary, size: 36),
              onPressed: controller.prev,
            ),
            GestureDetector(
              onTap: controller.togglePlay,
              child: Container(
                width: 64, height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  p.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  size: 36,
                  color: AppColors.background,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded, color: AppColors.textPrimary, size: 36),
              onPressed: controller.next,
            ),
            IconButton(
              icon: const Icon(Icons.queue_music_rounded, color: AppColors.textSecondary, size: 24),
              onPressed: () {},
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(icon: const Icon(Icons.comment_outlined, color: AppColors.textTertiary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_outlined, color: AppColors.textTertiary), onPressed: () {}),
          IconButton(icon: const Icon(Icons.download_outlined, color: AppColors.textTertiary), onPressed: () {}),
        ],
      ),
    );
  }

  IconData _playModeIcon(mode) {
    switch (mode) {
      case PlayMode.sequence: return Icons.repeat_rounded;
      case PlayMode.loop: return Icons.repeat_rounded;
      case PlayMode.single: return Icons.repeat_one_rounded;
      case PlayMode.shuffle: return Icons.shuffle_rounded;
      default: return Icons.repeat_rounded;
    }
  }
}
