import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../config/theme/app_dimensions.dart';
import '../../data/models/song_model.dart';
import '../../core/utils/formatters.dart';

/// 歌曲列表项组件
class SongTile extends StatelessWidget {
  final SongModel song;
  final int? index;
  final bool isPlaying;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const SongTile({
    super.key,
    required this.song,
    this.index,
    this.isPlaying = false,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.pagePadding,
          vertical: 10,
        ),
        child: Row(
          children: [
            // 序号
            if (index != null)
              SizedBox(
                width: 28,
                child: Text(
                  isPlaying ? '♪' : '${index! + 1}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isPlaying || index! < 3 ? FontWeight.w700 : FontWeight.w500,
                    color: isPlaying || index! < 3
                        ? AppColors.accent
                        : AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (index != null) const SizedBox(width: 12),

            // 封面
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: Container(
                width: 44,
                height: 44,
                color: AppColors.surface,
                child: song.coverUrl.isNotEmpty
                    ? Image.network(
                        '${song.coverUrl}?param=88x88',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: AppColors.textTertiary, size: 20),
                      )
                    : const Icon(Icons.music_note, color: AppColors.textTertiary, size: 20),
              ),
            ),
            const SizedBox(width: 12),

            // 歌曲信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (song.isVip) ...[
                        _badge('VIP', AppColors.accent),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          song.name,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isPlaying ? AppColors.accent : AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${song.artistText} · ${song.albumName}',
                    style: AppTextStyles.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // 时长
            Text(
              Formatters.durationMs(song.duration),
              style: AppTextStyles.caption,
            ),

            // 更多
            if (onMore != null)
              GestureDetector(
                onTap: onMore,
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.more_vert, size: 18, color: AppColors.textTertiary),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4), width: 0.5),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(text, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w500)),
    );
  }
}
