import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/widgets/skeleton.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../shared/services/player_service.dart';
import 'playlist_controller.dart';

class PlaylistPage extends GetView<PlaylistController> {
  const PlaylistPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.detailId.value != null ? _buildDetail() : _buildSquare());
  }

  // === 歌单广场 ===
  Widget _buildSquare() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('歌单广场')),
      body: Obx(() {
        if (controller.isLoadingSquare.value) return const DetailSkeleton();
        return CustomScrollView(slivers: [
          // 分类标签
          SliverToBoxAdapter(child: SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: ['全部', ...controller.categories.values.expand((v) => v)].take(15).map((cat) =>
                GestureDetector(
                  onTap: () => controller.changeCat(cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: controller.currentCat.value == cat ? AppColors.accentLight : AppColors.glass,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: controller.currentCat.value == cat ? AppColors.accent.withOpacity(0.3) : AppColors.glassBorder, width: 0.5),
                    ),
                    child: Text(cat, style: TextStyle(fontSize: 13, color: controller.currentCat.value == cat ? AppColors.accent : AppColors.textSecondary)),
                  ),
                )).toList(),
            ),
          )),
          // 精品歌单
          if (controller.highQuality.isNotEmpty) SliverToBoxAdapter(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 12), child: Text('精品歌单', style: AppTextStyles.h3)),
              SizedBox(height: 160, child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.highQuality.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) {
                  final p = controller.highQuality[i];
                  return _playlistCard(p);
                },
              )),
            ],
          )),
          // 热门歌单
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('热门歌单', style: AppTextStyles.h3),
              Text(controller.currentCat.value, style: AppTextStyles.caption),
            ]),
          )),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 0.72),
              delegate: SliverChildBuilderDelegate((_, i) {
                final p = controller.topPlaylists[i];
                return GestureDetector(
                  onTap: () => Get.toNamed('/playlist/detail', arguments: {'id': p.id}),
                  child: Column(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(14), child:
                      Stack(children: [
                        Container(width: double.infinity, color: AppColors.surface,
                          child: Image.network('${p.coverUrl}?param=240x240', fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.music_note, color: AppColors.textTertiary, size: 36)))),
                        Positioned(top: 6, right: 6, child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.play_arrow_rounded, size: 10, color: Colors.white),
                            Text(Formatters.playCount(p.playCount), style: const TextStyle(fontSize: 10, color: Colors.white)),
                          ]),
                        )),
                      ])),
                    const SizedBox(height: 6),
                    Text(p.name, style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
                  ]),
                );
              }, childCount: controller.topPlaylists.length),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 200)),
        ]);
      }),
    );
  }

  // === 歌单详情 ===
  Widget _buildDetail() {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoadingDetail.value) return const DetailSkeleton();
        final d = controller.detail.value;
        final name = d['name'] ?? '';
        final cover = d['coverImgUrl'] ?? '';
        final desc = d['description'] ?? '';
        final creator = d['creator'] ?? {};
        final trackCount = d['trackCount'] ?? 0;
        final playCount = d['playCount'] ?? 0;

        return CustomScrollView(slivers: [
          // 顶部
          SliverAppBar(
            expandedHeight: 300, pinned: true, backgroundColor: AppColors.background,
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Get.back()),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(fit: StackFit.expand, children: [
                Image.network('$cover?param=828x600', fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(color: AppColors.surface)),
                Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xCC0A0A0A)]))),
                Positioned(left: 16, right: 16, bottom: 16, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  ClipRRect(borderRadius: BorderRadius.circular(16), child:
                    Container(width: 120, height: 120, color: AppColors.surface,
                      child: Image.network('$cover?param=240x240', fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.music_note, size: 48, color: AppColors.textTertiary)))),
                  const SizedBox(width: 16),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(name, style: AppTextStyles.h3.copyWith(color: Colors.white), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 8),
                    Row(children: [
                      CircleAvatar(radius: 12, backgroundColor: AppColors.surface,
                        backgroundImage: creator['avatarUrl'] != null ? NetworkImage('${creator['avatarUrl']}?param=48x48') : null),
                      const SizedBox(width: 6),
                      Text(creator['nickname'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ]),
                    const SizedBox(height: 8),
                    Text(Formatters.playCount(playCount) + '次播放', style: const TextStyle(fontSize: 11, color: Colors.white54)),
                  ])),
                ])),
              ]),
            ),
          ),
          // 操作栏
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _action(Icons.favorite_border_rounded, '${d['subscribedCount'] ?? 0}'),
              _action(Icons.chat_bubble_outline_rounded, '${d['commentCount'] ?? 0}'),
              _action(Icons.share_outlined, '${d['shareCount'] ?? 0}'),
              _action(Icons.download_outlined, '下载'),
            ]),
          )),
          // 播放全部
          SliverToBoxAdapter(child: GestureDetector(
            onTap: () {
              if (controller.tracks.isNotEmpty) {
                Get.find<PlayerService>().playSong(controller.tracks.first, list: controller.tracks, index: 0);
                Get.toNamed('/player');
              }
            },
            child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child:
              Row(children: [
                Container(width: 34, height: 34, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(50)),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20)),
                const SizedBox(width: 10),
                Text('播放全部', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(width: 4),
                Text('($trackCount)', style: AppTextStyles.caption),
              ])),
          )),
          // 歌曲列表
          SliverList(delegate: SliverChildBuilderDelegate((_, i) {
            final song = controller.tracks[i];
            return GestureDetector(
              onTap: () {
                Get.find<PlayerService>().playSong(song, list: controller.tracks, index: i);
                Get.toNamed('/player');
              },
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(children: [
                  SizedBox(width: 28, child: Text('${i+1}', style: TextStyle(fontSize: 15, fontWeight: i < 3 ? FontWeight.w700 : FontWeight.w500, color: i < 3 ? AppColors.accent : AppColors.textTertiary))),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(song.name, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                    Text('${song.artistText} · ${song.albumName}', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ])),
                  Text(Formatters.durationMs(song.duration), style: AppTextStyles.caption),
                ]),
              ),
            );
          }, childCount: controller.tracks.length)),
          // 简介
          if (desc.isNotEmpty) SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('歌单简介', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 8),
              Text(desc, style: AppTextStyles.caption, maxLines: 5, overflow: TextOverflow.ellipsis),
            ]),
          )),
          const SliverToBoxAdapter(child: SizedBox(height: 200)),
        ]);
      }),
    );
  }

  Widget _playlistCard(p) => SizedBox(width: 120, child: GestureDetector(
    onTap: () => Get.toNamed('/playlist/detail', arguments: {'id': p.id}),
    child: Column(children: [
      ClipRRect(borderRadius: BorderRadius.circular(14), child:
        Container(width: 120, height: 120, color: AppColors.surface,
          child: Image.network('${p.coverUrl}?param=240x240', fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.music_note, color: AppColors.textTertiary, size: 36))))),
      const SizedBox(height: 8),
      Text(p.name, style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
    ]),
  ));

  Widget _action(IconData icon, String label) => Column(children: [
    Icon(icon, size: 22, color: AppColors.textSecondary),
    const SizedBox(height: 4),
    Text(label, style: AppTextStyles.caption),
  ]);
}
