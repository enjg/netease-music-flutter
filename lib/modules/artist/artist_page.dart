import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../shared/services/player_service.dart';
import 'artist_controller.dart';

class ArtistPage extends GetView<ArtistController> {
  const ArtistPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.background, body: Obx(() {
      if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.accent));
      final d = controller.detail.value;
      return DefaultTabController(length: 4, child: CustomScrollView(slivers: [
        SliverAppBar(expandedHeight: 280, pinned: true, backgroundColor: AppColors.background,
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Get.back()),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(fit: StackFit.expand, children: [
              Image.network('${d['cover'] ?? ''}?param=828x560', fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: AppColors.surface)),
              Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Color(0xCC0A0A0A)]))),
              Positioned(left: 16, bottom: 16, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(d['name'] ?? '', style: AppTextStyles.h1.copyWith(color: Colors.white)),
                if ((d['alias'] as List?)?.isNotEmpty == true)
                  Text((d['alias'] as List).join(' / '), style: const TextStyle(fontSize: 13, color: Colors.white54)),
                const SizedBox(height: 8),
                Row(children: [
                  _stat('${d['musicSize'] ?? 0}', '歌曲'),
                  const SizedBox(width: 16),
                  _stat('${d['albumSize'] ?? 0}', '专辑'),
                  const SizedBox(width: 16),
                  _stat(Formatters.number(d['fansCount'] ?? 0), '粉丝'),
                ]),
              ])),
            ]),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.accent, labelColor: AppColors.textPrimary, unselectedLabelColor: AppColors.textTertiary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: const [Tab(text: '歌曲'), Tab(text: '专辑'), Tab(text: 'MV'), Tab(text: '详情')],
          ),
        ),
        SliverFillRemaining(child: TabBarView(children: [
          // 歌曲
          ListView.builder(itemCount: controller.songs.length, itemBuilder: (_, i) {
            final s = controller.songs[i];
            return GestureDetector(
              onTap: () { Get.find<PlayerService>().playSong(s, list: controller.songs, index: i); Get.toNamed('/player'); },
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), child: Row(children: [
                SizedBox(width: 28, child: Text('${i+1}', style: TextStyle(fontSize: 15, fontWeight: i < 3 ? FontWeight.w700 : FontWeight.w500, color: i < 3 ? AppColors.accent : AppColors.textTertiary))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(s.name, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(s.albumName, style: AppTextStyles.caption),
                ])),
                Text(Formatters.durationMs(s.duration), style: AppTextStyles.caption),
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
          // MV
          GridView.builder(padding: const EdgeInsets.all(16), gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 16/9),
            itemCount: controller.mvs.length, itemBuilder: (_, i) {
            final m = controller.mvs[i];
            return ClipRRect(borderRadius: BorderRadius.circular(12), child: Container(color: AppColors.surface,
              child: Stack(fit: StackFit.expand, children: [
                Image.network('${m['imgurl'] ?? ''}?param=480x270', fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.videocam, color: AppColors.textTertiary))),
                Positioned(bottom: 6, left: 6, child: Text(m['name'] ?? '', style: const TextStyle(fontSize: 11, color: Colors.white), maxLines: 1)),
              ])));
          }),
          // 详情
          SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (controller.desc.value.isNotEmpty) ...[
              const Text('简介', style: AppTextStyles.h3),
              const SizedBox(height: 8),
              Text(controller.desc.value, style: AppTextStyles.bodySmall.copyWith(height: 1.8)),
            ],
            if (controller.similar.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text('相似歌手', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              ...controller.similar.map((a) => GestureDetector(
                onTap: () => Get.toNamed('/artist/detail', arguments: {'id': a['id']}),
                child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [
                  CircleAvatar(radius: 24, backgroundColor: AppColors.surface,
                    backgroundImage: a['picUrl'] != null ? NetworkImage('${a['picUrl']}?param=96x96') : null),
                  const SizedBox(width: 12),
                  Text(a['name'] ?? '', style: AppTextStyles.bodyMedium),
                ])),
              )),
            ],
          ])),
        ])),
      ]));
    }));
  }

  Widget _stat(String n, String l) => Column(children: [
    Text(n, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
    Text(l, style: const TextStyle(fontSize: 10, color: Colors.white54)),
  ]);
}
