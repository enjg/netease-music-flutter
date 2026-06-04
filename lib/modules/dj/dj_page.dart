import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'dj_controller.dart';

/// 电台页面
class DjPage extends GetView<DjController> {
  const DjPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('电台'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refresh(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.accent));
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => controller.refresh(),
          child: CustomScrollView(
            slivers: [
              // 推荐电台
              if (controller.personalizeDjs.isNotEmpty)
                _buildSection('电台推荐', controller.personalizeDjs, _buildDjCard),

              // 热门电台
              if (controller.hotDjs.isNotEmpty)
                _buildSection('热门电台', controller.hotDjs, _buildDjCard),

              // 排行榜
              if (controller.toplist.isNotEmpty)
                _buildSection('电台排行榜', controller.toplist.take(10).toList(), _buildToplistItem),

              const SliverToBoxAdapter(child: SizedBox(height: 200)),
            ],
          ),
        );
      }),
    );
  }

  /// 构建区块
  Widget _buildSection(
    String title,
    List<Map<String, dynamic>> items,
    Widget Function(Map<String, dynamic>) builder,
  ) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Text(title, style: AppTextStyles.h3),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text('查看更多'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 180,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) => builder(items[i]),
            ),
          ),
        ],
      ),
    );
  }

  /// 构建电台卡片
  Widget _buildDjCard(Map<String, dynamic> dj) {
    return GestureDetector(
      onTap: () => Get.toNamed('/dj/detail', arguments: {'id': dj['id']}),
      child: SizedBox(
        width: 130,
        child: Column(
          children: [
            // 封面
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 130,
                height: 130,
                color: AppColors.surface,
                child: Stack(
                  children: [
                    Image.network(
                      '${dj['picUrl'] ?? ''}?param=260x260',
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(Icons.radio, color: AppColors.textTertiary),
                      ),
                    ),
                    // 订阅数
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.headset, size: 12, color: Colors.white70),
                            const SizedBox(width: 2),
                            Text(
                              Formatters.number(dj['subCount'] ?? 0),
                              style: const TextStyle(fontSize: 10, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            // 名称
            Text(
              dj['name'] ?? '',
              style: AppTextStyles.caption,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// 构建排行榜项
  Widget _buildToplistItem(Map<String, dynamic> item) {
    final dj = item['program']?['radio'] ?? {};
    return GestureDetector(
      onTap: () => Get.toNamed('/dj/detail', arguments: {'id': dj['id']}),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.glassBorder, width: 0.5),
        ),
        child: Row(
          children: [
            // 排名
            SizedBox(
              width: 24,
              child: Text(
                '${item['rank'] ?? ''}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: (item['rank'] ?? 0) <= 3 ? AppColors.accent : AppColors.textTertiary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 封面
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 50,
                height: 50,
                color: AppColors.surface,
                child: Image.network(
                  '${dj['picUrl'] ?? ''}?param=100x100',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.radio, size: 24, color: AppColors.textTertiary),
                ),
              ),
            ),
            const SizedBox(width: 10),
            // 信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dj['name'] ?? '',
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${Formatters.number(dj['subCount'] ?? 0)} 订阅',
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
