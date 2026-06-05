import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/widgets/skeleton.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../shared/services/player_service.dart';
import 'album_controller.dart';

class AlbumPage extends GetView<AlbumController> {
  const AlbumPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, body: Obx(() {
      if (controller.isLoading.value) return const DetailSkeleton();
      final a = controller.album.value;
      final artist = a['artist'] ?? {};
      return CustomScrollView(slivers: [
        SliverAppBar(expandedHeight: 300, pinned: true, backgroundColor: AppColors.background,
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Get.back()),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              Image.network('${a['picUrl'] ?? ''}?param=828x600', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface)),
              Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xCC0A0A0A)]))),
              Positioned(left: 16, right: 16, bottom: 16, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                ClipRRect(borderRadius: BorderRadius.circular(16), child: Container(width: 120, height: 120, color: AppColors.surface,
                  child: Image.network('${a['picUrl'] ?? ''}?param=240x240', fit: BoxFit.cover))),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(a['name'] ?? '', style: AppTextStyles.h3.copyWith(color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 6),
                  Text(artist['name'] ?? '', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text(Formatters.date(a['publishTime'] ?? 0) + ' · ${(a['size'] ?? 0)}首', style: const TextStyle(fontSize: 11, color: Colors.white54)),
                ])),
              ])),
            ]),
          ),
        ),
        // 操作栏
        SliverToBoxAdapter(child: Container(
          margin: const EdgeInsets.all(16), padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _action(Icons.favorite_border_rounded, '${controller.dynamicInfo.value['likedCount'] ?? 0}'),
            _action(Icons.chat_bubble_outline_rounded, '${controller.dynamicInfo.value['commentCount'] ?? 0}'),
            _action(Icons.share_outlined, '${controller.dynamicInfo.value['shareCount'] ?? 0}'),
          ]),
        )),
        // 歌曲列表
        SliverList(delegate: SliverChildBuilderDelegate((_, i) {
          final s = controller.songs[i];
          return GestureDetector(
            onTap: () { Get.find<PlayerService>().playSong(s, list: controller.songs, index: i); Get.toNamed('/player'); },
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: Row(children: [
              SizedBox(width: 28, child: Text('${i+1}', style: TextStyle(fontSize: 15, fontWeight: i < 3 ? FontWeight.w700 : FontWeight.w500, color: i < 3 ? AppColors.accent : AppColors.textTertiary))),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(s.artistText, style: AppTextStyles.caption),
              ])),
              Text(Formatters.durationMs(s.duration), style: AppTextStyles.caption),
            ])),
          );
        }, childCount: controller.songs.length)),
        // 简介
        if ((a['description'] ?? '').toString().isNotEmpty) SliverToBoxAdapter(child: Container(
          margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('专辑简介', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            Text(a['description'], style: AppTextStyles.caption.copyWith(height: 1.6), maxLines: 5, overflow: TextOverflow.ellipsis),
          ]),
        )),
        // 评论
        if (controller.comments.isNotEmpty) SliverToBoxAdapter(child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16), padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('精彩评论 (${controller.comments.length})', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 12),
            ...controller.comments.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CircleAvatar(radius: 15, backgroundColor: AppColors.surface,
                backgroundImage: c['user']?['avatarUrl'] != null ? NetworkImage('${c['user']['avatarUrl']}?param=60x60') : null),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c['user']?['nickname'] ?? '', style: AppTextStyles.caption),
                const SizedBox(height: 4),
                Text(c['content'] ?? '', style: AppTextStyles.bodySmall, maxLines: 3, overflow: TextOverflow.ellipsis),
                Text('❤️ ${Formatters.number(c['likedCount'] ?? 0)}', style: AppTextStyles.caption),
              ])),
            ]))),
          ]),
        )),
        // 相似专辑
        if (controller.similar.isNotEmpty) SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('相似专辑', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            SizedBox(height: 160, child: ListView.separated(scrollDirection: Axis.horizontal,
              itemCount: controller.similar.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final s = controller.similar[i];
                return GestureDetector(onTap: () => Get.toNamed('/album/detail', arguments: {'id': s['id']}), child: SizedBox(width: 120, child: Column(children: [
                  ClipRRect(borderRadius: BorderRadius.circular(14), child: Container(width: 120, height: 120, color: AppColors.surface,
                    child: Image.network('${s['picUrl'] ?? ''}?param=240x240', fit: BoxFit.cover))),
                  const SizedBox(height: 6),
                  Text(s['name'] ?? '', style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
                ])));
              },
            )),
          ]),
        )),
        const SliverToBoxAdapter(child: SizedBox(height: 200)),
      ]);
    }));
  }

  Widget _action(IconData icon, String label) => Column(children: [
    Icon(icon, size: 22, color: AppColors.textSecondary),
    const SizedBox(height: 4),
    Text(label, style: AppTextStyles.caption),
  ]);
}
