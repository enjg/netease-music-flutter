import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/widgets/skeleton.dart';
import '../../config/theme/app_text_styles.dart';
import '../../shared/services/player_service.dart';
import 'style_controller.dart';

class StylePage extends GetView<StyleController> {
  const StylePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Obx(() => Text(controller.selectedTagId.value > 0 ? '风格详情' : '风格'))),
      body: Obx(() {
        if (controller.isLoading.value) return const GridSkeleton();
        if (controller.selectedTagId.value > 0) return _buildDetail();
        return _buildHome();
      }),
    );
  }

  Widget _buildHome() {
    final colors = [0xFFE74C3C, 0xFF3498DB, 0xFF2ECC71, 0xFFF39C12, 0xFF9B59B6, 0xFF1ABC9C, 0xFFE67E22, 0xFFE91E63, 0xFF00BCD4, 0xFFFF5722];
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2),
      itemCount: controller.styles.length.clamp(0, 20),
      itemBuilder: (_, i) {
        final s = controller.styles[i];
        final color = Color(colors[i % colors.length]);
        return GestureDetector(
          onTap: () => controller.loadDetail(s['tagId'] ?? 0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color.withOpacity(0.2), color.withOpacity(0.05)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.15), width: 0.5),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
              Text(s['tagName'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              Text(s['enName'] ?? '', style: TextStyle(fontSize: 11, color: color.withOpacity(0.7))),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildDetail() {
    return DefaultTabController(length: 4, child: Column(children: [
      TabBar(
        indicatorColor: AppColors.accent, labelColor: AppColors.textPrimary, unselectedLabelColor: AppColors.textTertiary,
        tabs: const [Tab(text: '歌曲'), Tab(text: '专辑'), Tab(text: '歌手'), Tab(text: '歌单')],
      ),
      Expanded(child: TabBarView(children: [
        // 歌曲
        ListView.builder(itemCount: controller.songs.length, itemBuilder: (_, i) {
          final s = controller.songs[i];
          return GestureDetector(
            onTap: () { Get.find<PlayerService>().playSong(s, list: controller.songs, index: i); Get.toNamed('/player'); },
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: Row(children: [
              SizedBox(width: 28, child: Text('${i+1}', style: TextStyle(color: i < 3 ? AppColors.accent : AppColors.textTertiary, fontWeight: i < 3 ? FontWeight.w700 : FontWeight.w500))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(s.artistText, style: AppTextStyles.caption),
              ])),
            ])),
          );
        }),
        // 专辑
        GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.75),
          itemCount: controller.albums.length, itemBuilder: (_, i) {
          final a = controller.albums[i];
          return GestureDetector(onTap: () => Get.toNamed('/album/detail', arguments: {'id': a['id']}), child: Column(children: [
            ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(width: double.infinity, color: AppColors.surface,
              child: Image.network('${a['picUrl'] ?? ''}?param=240x240', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.album, color: AppColors.textTertiary))))),
            const SizedBox(height: 6),
            Text(a['name'] ?? '', style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
          ]));
        }),
        // 歌手
        ListView.builder(itemCount: controller.artists.length, itemBuilder: (_, i) {
          final a = controller.artists[i];
          return GestureDetector(
            onTap: () => Get.toNamed('/artist/detail', arguments: {'id': a['id']}),
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(children: [
              CircleAvatar(radius: 26, backgroundColor: AppColors.surface,
                backgroundImage: a['picUrl'] != null ? NetworkImage('${a['picUrl']}?param=104x104') : null),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(a['name'] ?? '', style: AppTextStyles.bodyMedium),
                Text('${a['musicSize'] ?? 0}首歌曲', style: AppTextStyles.caption),
              ])),
            ])),
          );
        }),
        // 歌单
        GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.72),
          itemCount: controller.playlists.length, itemBuilder: (_, i) {
          final p = controller.playlists[i];
          return GestureDetector(onTap: () => Get.toNamed('/playlist/detail', arguments: {'id': p['id']}), child: Column(children: [
            ClipRRect(borderRadius: BorderRadius.circular(14), child: Container(width: double.infinity, color: AppColors.surface,
              child: Image.network('${p['coverImgUrl'] ?? ''}?param=240x240', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.music_note, color: AppColors.textTertiary))))),
            const SizedBox(height: 6),
            Text(p['name'] ?? '', style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
          ]));
        }),
      ])),
    ]));
  }
}
