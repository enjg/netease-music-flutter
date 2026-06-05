import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/skeleton.dart';
import 'video_controller.dart';

class VideoPage extends GetView<VideoController> {
  const VideoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) return const DetailSkeleton();
        final detail = controller.detail.value;
        final info = controller.detailInfo.value;
        return CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 250, pinned: true, backgroundColor: AppColors.background,
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Get.back()),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(color: AppColors.surface,
                child: Stack(alignment: Alignment.center, children: [
                  Image.network('${detail['coverUrl'] ?? ''}?param=828x466', width: double.infinity, height: 250, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppColors.surface, child: const Icon(Icons.videocam, size: 48, color: AppColors.textTertiary))),
                  Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), shape: BoxShape.circle),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 36)),
                ]),
              ),
            ),
          ),
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(detail['title'] ?? '', style: AppTextStyles.h2, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 8),
              Row(children: [
                _stat(Icons.play_circle_outline, '${Formatters.number(info['playCount'] ?? 0)}次播放'),
                const SizedBox(width: 16),
                _stat(Icons.thumb_up_outlined, '${Formatters.number(info['likedCount'] ?? 0)}赞'),
                const SizedBox(width: 16),
                _stat(Icons.chat_bubble_outline, '${Formatters.number(info['commentCount'] ?? 0)}评论'),
              ]),
              const SizedBox(height: 16),
              // 操作栏
              Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.glassBorder, width: 0.5)),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  _actionBtn(info['liked'] == true ? Icons.favorite : Icons.favorite_border, '赞', info['liked'] == true ? AppColors.accent : null),
                  GestureDetector(onTap: () => controller.toggleSubscribe(),
                    child: _actionBtn(info['isSub'] == true ? Icons.bookmark : Icons.bookmark_border, '收藏', info['isSub'] == true ? AppColors.accent : null)),
                  _actionBtn(Icons.share_outlined, '分享'),
                ]),
              ),
            ],
          ))),
          // 相关视频
          if (controller.relatedVideos.isNotEmpty)
            SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.all(16), child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('相关视频', style: AppTextStyles.h3),
                const SizedBox(height: 12),
                ...controller.relatedVideos.take(5).map((v) => GestureDetector(
                  onTap: () => Get.toNamed('/video/detail', arguments: {'vid': v['vid']}),
                  child: Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(children: [
                    ClipRRect(borderRadius: BorderRadius.circular(8),
                      child: Container(width: 120, height: 68, color: AppColors.surface,
                        child: Image.network('${v['coverUrl'] ?? ''}?param=240x136', fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(Icons.videocam, color: AppColors.textTertiary)))),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(v['title'] ?? '', style: AppTextStyles.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text(Formatters.number(v['playCount'] ?? 0) + '次播放', style: AppTextStyles.caption),
                    ])),
                  ])),
                )),
              ],
            ))),
          const SliverToBoxAdapter(child: SizedBox(height: 200)),
        ]);
      }),
    );
  }

  Widget _stat(IconData icon, String text) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 14, color: AppColors.textTertiary), const SizedBox(width: 4), Text(text, style: AppTextStyles.caption),
  ]);

  Widget _actionBtn(IconData icon, String label, [Color? color, VoidCallback? onTap]) => GestureDetector(
    onTap: onTap,
    child: Column(children: [
      Icon(icon, size: 22, color: color ?? AppColors.textSecondary),
      const SizedBox(height: 4),
      Text(label, style: AppTextStyles.caption),
    ]),
  );
}
