import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_dimensions.dart';
import '../../../app/routes.dart';

/// 快捷入口网格 - 液态玻璃风格
class QuickEntries extends StatelessWidget {
  const QuickEntries({super.key});

  @override
  Widget build(BuildContext context) {
    final entries = [
      _Entry(Icons.radio_rounded, '私人FM', AppRoutes.fm),
      _Entry(Icons.library_music_rounded, '歌单', AppRoutes.playlistSquare),
      _Entry(Icons.leaderboard_rounded, '排行榜', AppRoutes.charts),
      _Entry(Icons.mic_rounded, '歌手', AppRoutes.artistDetail),
      _Entry(Icons.palette_rounded, '风格', AppRoutes.style),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: entries.map((e) => GestureDetector(
          onTap: () => Get.toNamed(e.route),
          child: Column(
            children: [
              Container(
                width: 52, height: 52,
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  border: Border.all(color: AppColors.glassBorder, width: 0.5),
                ),
                child: Icon(e.icon, size: 24, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Text(e.label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ),
        )).toList(),
      ),
    );
  }
}

class _Entry {
  final IconData icon;
  final String label;
  final String route;
  _Entry(this.icon, this.label, this.route);
}
