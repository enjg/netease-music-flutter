import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import 'fm_controller.dart';

class FmPage extends GetView<FmController> {
  const FmPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.3),
            radius: 0.8,
            colors: [Color(0xFF1a0a2e), Color(0xFF0a0a0a)],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            final song = controller.currentSong.value;
            if (song == null) {
              return const Center(child: CircularProgressIndicator(color: AppColors.accent));
            }
            return Column(
              children: [
                // 导航栏
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                        onPressed: () => Get.back(),
                      ),
                      const Spacer(),
                      const Text('私人FM', style: AppTextStyles.navTitle),
                      const Spacer(),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(),

                // 封面
                ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    width: 260, height: 260,
                    color: AppColors.surface,
                    child: song.coverUrl.isNotEmpty
                        ? Image.network('${song.coverUrl}?param=520x520', fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 80, color: AppColors.textTertiary))
                        : const Icon(Icons.music_note, size: 80, color: AppColors.textTertiary),
                  ),
                ),

                const Spacer(),

                // 歌曲信息
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text(song.name, style: AppTextStyles.h2, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      Text(song.artistText, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 进度条
                Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: controller.progress.value,
                        backgroundColor: AppColors.textTertiary.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                        minHeight: 3,
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                )),

                // 控制按钮
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 喜欢
                    Obx(() => IconButton(
                      icon: Icon(
                        controller.isLiked.value ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: controller.isLiked.value ? AppColors.accent : AppColors.textSecondary,
                        size: 28,
                      ),
                      onPressed: controller.toggleLike,
                    )),
                    const SizedBox(width: 32),
                    // 播放/暂停
                    Obx(() => GestureDetector(
                      onTap: controller.togglePlay,
                      child: Container(
                        width: 64, height: 64,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                        child: Icon(
                          controller.isPlaying.value ? Icons.pause_rounded : Icons.play_arrow_rounded,
                          size: 36, color: AppColors.background,
                        ),
                      ),
                    )),
                    const SizedBox(width: 32),
                    // 下一首
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded, color: AppColors.textSecondary, size: 32),
                      onPressed: controller.next,
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 垃圾桶
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textTertiary),
                  onPressed: controller.trash,
                ),
                const SizedBox(height: 40),
              ],
            );
          }),
        ),
      ),
    );
  }
}
