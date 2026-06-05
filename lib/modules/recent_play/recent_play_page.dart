import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../shared/widgets/skeleton.dart';
import '../../shared/services/player_service.dart';
import 'recent_play_controller.dart';

class RecentPlayPage extends GetView<RecentPlayController> {
  const RecentPlayPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('最近播放')),
      body: Obx(() {
        if (controller.isLoading.value) return const ListSkeleton();
        if (controller.songs.isEmpty) return const Center(child: Text('暂无播放记录', style: TextStyle(color: AppColors.textTertiary)));
        return ListView.builder(
          itemCount: controller.songs.length,
          padding: const EdgeInsets.only(bottom: 200),
          itemBuilder: (_, i) {
            final s = controller.songs[i];
            return ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8),
                child: Container(width: 48, height: 48, color: AppColors.surface,
                  child: Image.network('${s.coverUrl}?param=96x96', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: AppColors.textTertiary, size: 24)))),
              title: Text(s.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
              subtitle: Text(s.artistText, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              onTap: () {
                Get.find<PlayerService>().playSong(s, list: controller.songs, index: i);
                Get.toNamed('/player');
              },
            );
          },
        );
      }),
    );
  }
}
