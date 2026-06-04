import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../config/theme/app_colors.dart';

/// 骨架屏加载组件
class Skeleton extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const Skeleton({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surface,
      highlightColor: AppColors.surfaceVariant,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }

  /// 圆形骨架
  static Widget circle(double size) {
    return Skeleton(width: size, height: size, radius: size / 2);
  }

  /// 歌曲列表骨架
  static Widget songList({int count = 5}) {
    return Column(
      children: List.generate(count, (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Skeleton(width: 28, height: 14, radius: 4),
            const SizedBox(width: 12),
            const Skeleton(width: 44, height: 44, radius: 8),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Skeleton(width: 140, height: 14, radius: 4),
                  SizedBox(height: 6),
                  Skeleton(width: 100, height: 12, radius: 4),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  /// 网格骨架
  static Widget grid({int count = 6, double itemSize = 120}) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(count, (_) => Column(
        children: [
          Skeleton(width: itemSize, height: itemSize, radius: 14),
          const SizedBox(height: 8),
          Skeleton(width: itemSize, height: 12, radius: 4),
        ],
      )),
    );
  }
}
