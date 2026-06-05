import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';

/// 推荐歌单横滑区域
class PlaylistSection extends StatelessWidget {
  final List<Map<String, dynamic>> playlists;
  final void Function(Map<String, dynamic> playlist)? onPlaylistTap;
  const PlaylistSection({super.key, required this.playlists, this.onPlaylistTap});

  @override
  Widget build(BuildContext context) {
    if (playlists.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('推荐歌单', style: AppTextStyles.h3),
          GestureDetector(
            onTap: () => Get.toNamed('/playlist/square'),
            child: const Text('更多 ›', style: AppTextStyles.caption)),
        ]),
      ),
      SizedBox(height: 160,
        child: ListView.separated(scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: playlists.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, i) {
            final p = playlists[i];
            return GestureDetector(
              onTap: () => onPlaylistTap?.call(p),
              child: SizedBox(width: 120, child: Column(children: [
                ClipRRect(borderRadius: BorderRadius.circular(14),
                  child: Stack(children: [
                    Container(width: 120, height: 120, color: AppColors.surface,
                      child: Image.network('${p['picUrl']}?param=240x240', fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.music_note, color: AppColors.textTertiary, size: 36)))),
                    Positioned(top: 6, right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(6)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.play_arrow_rounded, size: 10, color: Colors.white),
                          Text(Formatters.playCount(p['playCount'] ?? 0),
                            style: const TextStyle(fontSize: 10, color: Colors.white)),
                        ]))),
                  ])),
                const SizedBox(height: 8),
                Text(p['name'] ?? '', style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
              ])),
            );
          }),
      ),
    ]);
  }
}
