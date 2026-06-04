import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'mv_controller.dart';

/// MV 详情页面
class MvPage extends GetView<MvController> {
  const MvPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }

        final detail = controller.detail.value;
        final info = controller.detailInfo.value;

        return CustomScrollView(
          slivers: [
            // MV 播放器区域
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: AppColors.surface,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // 封面图
                      Image.network(
                        '${detail['cover'] ?? ''}?param=828x466',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.surface,
                          child: const Center(
                            child: Icon(Icons.music_video, size: 48, color: AppColors.textTertiary),
                          ),
                        ),
                      ),
                      // 播放按钮
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow, color: Colors.white, size: 36),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // MV 信息
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 标题
                    Text(
                      detail['name'] ?? '',
                      style: AppTextStyles.h2,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),

                    // 歌手
                    if (detail['artistName'] != null)
                      Text(
                        detail['artistName'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    const SizedBox(height: 12),

                    // 播放量和发布时间
                    Row(
                      children: [
                        _stat(Icons.play_circle_outline, '${Formatters.number(info['playCount'] ?? 0)} 次播放'),
                        const SizedBox(width: 16),
                        _stat(Icons.thumb_up_outlined, '${Formatters.number(info['likedCount'] ?? 0)} 赞'),
                        const SizedBox(width: 16),
                        _stat(Icons.chat_bubble_outline, '${Formatters.number(info['commentCount'] ?? 0)} 评论'),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 发布时间
                    Text(
                      '发布于 ${detail['publishTime'] ?? ''}',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),

            // 操作栏
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.glass,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.glassBorder, width: 0.5),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _actionButton(
                      icon: info['liked'] == true ? Icons.favorite : Icons.favorite_border,
                      label: '赞',
                      color: info['liked'] == true ? AppColors.accent : AppColors.textSecondary,
                      onTap: () {},
                    ),
                    _actionButton(
                      icon: info['subed'] == true ? Icons.bookmark : Icons.bookmark_border,
                      label: '收藏',
                      color: info['subed'] == true ? AppColors.accent : AppColors.textSecondary,
                      onTap: () => controller.toggleSubscribe(),
                    ),
                    _actionButton(
                      icon: Icons.share_outlined,
                      label: '分享',
                      onTap: () {},
                    ),
                    _actionButton(
                      icon: Icons.download_outlined,
                      label: '下载',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),

            // 相似 MV
            if (controller.similarMvs.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('相似 MV', style: AppTextStyles.h3),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.similarMvs.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (_, i) => _mvCard(controller.similarMvs[i]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 200)),
          ],
        );
      }),
    );
  }

  Widget _stat(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(text, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 22, color: color ?? AppColors.textSecondary),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _mvCard(Map mv) {
    return GestureDetector(
      onTap: () => Get.toNamed('/mv/detail', arguments: {'mvid': mv['id']}),
      child: SizedBox(
        width: 160,
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 160,
                height: 90,
                color: AppColors.surface,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      '${mv['cover'] ?? mv['picUrl'] ?? ''}?param=320x180',
                      width: 160,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.music_video,
                        color: AppColors.textTertiary,
                      ),
                    ),
                    const Icon(Icons.play_circle_outline, color: Colors.white70, size: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              mv['name'] ?? '',
              style: AppTextStyles.caption,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              mv['artistName'] ?? '',
              style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
