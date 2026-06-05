import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../app/routes.dart';
import '../../shared/widgets/skeleton.dart';
import 'podcast_controller.dart';

class PodcastPage extends GetView<PodcastController> {
  const PodcastPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) return const PodcastSkeleton();
          return RefreshIndicator(
            onRefresh: controller.loadData,
            color: AppColors.accent,
            child: CustomScrollView(slivers: [
              SliverToBoxAdapter(child: Padding(
                padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 16),
                child: Row(children: [
                  const Text('播客', style: AppTextStyles.h1),
                  const Spacer(),
                  _navBtn(Icons.search_rounded, () => Get.toNamed(AppRoutes.search)),
                ]),
              )),
              // 分类标签
              SliverToBoxAdapter(child: SizedBox(height: 40,
                child: ListView.separated(scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.categories.length.clamp(0, 10),
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final c = controller.categories[i];
                    return GestureDetector(
                      onTap: () {
                        // 分类点击 → 跳转DJ列表（可扩展为分类筛选）
                        Get.toNamed(AppRoutes.djList);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.glassBorder, width: 0.5)),
                        child: Text(c['name'] ?? '', style: const TextStyle(fontSize: 13, color: AppColors.textSecondary))),
                    );
                  }),
              )),
              // 推荐电台
              _section('推荐电台', controller.recommendDj, (item) => _djCard(item)),
              // 个性推荐
              _section('为你推荐', controller.personalRec, (item) => _djCard(item)),
              // 电台排行
              SliverToBoxAdapter(child: _sectionTitle('电台排行')),
              SliverList(delegate: SliverChildBuilderDelegate((_, i) {
                final d = controller.rankDj[i];
                return _rankItem(i, d);
              }, childCount: controller.rankDj.length.clamp(0, 10))),
              // 节目排行
              SliverToBoxAdapter(child: _sectionTitle('节目排行')),
              SliverList(delegate: SliverChildBuilderDelegate((_, i) {
                final p = controller.programRank[i];
                final prog = p['program'] ?? {};
                final song = prog['mainSong'] ?? {};
                return _rankItem(i, {
                  'name': song['name'] ?? prog['name'] ?? '',
                  'picUrl': song['album']?['picUrl'] ?? '',
                  'category': prog['radio']?['name'] ?? '',
                  'id': prog['radio']?['id'],
                });
              }, childCount: controller.programRank.length.clamp(0, 10))),
              const SliverToBoxAdapter(child: SizedBox(height: 200)),
            ]),
          );
        }),
      ),
    );
  }

  Widget _navBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(onTap: onTap,
      child: Container(width: 36, height: 36,
        decoration: BoxDecoration(color: AppColors.glass, shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorder, width: 0.5)),
        child: Icon(icon, size: 18, color: AppColors.textPrimary)));
  }

  Widget _section(String title, List list, Widget Function(Map) builder) {
    if (list.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle(title),
      SizedBox(height: 150,
        child: ListView.separated(scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (_, i) => builder(list[i].cast<String, dynamic>()))),
    ]));
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
    child: Text(title, style: AppTextStyles.h3));

  Widget _djCard(Map item) {
    return GestureDetector(
      onTap: () {
        final id = item['id'];
        if (id != null) Get.toNamed(AppRoutes.djDetail, arguments: {'id': id});
      },
      child: SizedBox(width: 110, child: Column(children: [
        ClipRRect(borderRadius: BorderRadius.circular(14),
          child: Container(width: 110, height: 110, color: AppColors.surface,
            child: Image.network('${item['picUrl'] ?? ''}?param=220x220', fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.podcasts, color: AppColors.textTertiary, size: 36))))),
        const SizedBox(height: 6),
        Text(item['name'] ?? '', style: AppTextStyles.caption, maxLines: 2, overflow: TextOverflow.ellipsis),
      ])),
    );
  }

  Widget _rankItem(int i, Map d) {
    return GestureDetector(
      onTap: () {
        final id = d['id'];
        if (id != null) Get.toNamed(AppRoutes.djDetail, arguments: {'id': id});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          SizedBox(width: 24, child: Text('${i+1}', style: TextStyle(
            fontSize: 15, fontWeight: i < 3 ? FontWeight.w700 : FontWeight.w500,
            color: i < 3 ? AppColors.accent : AppColors.textTertiary))),
          ClipRRect(borderRadius: BorderRadius.circular(8),
            child: Container(width: 44, height: 44, color: AppColors.surface,
              child: Image.network('${d['picUrl'] ?? ''}?param=88x88', fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.podcasts, color: AppColors.textTertiary, size: 20)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['name'] ?? '', style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(d['category'] ?? '', style: AppTextStyles.caption),
          ])),
        ])),
    );
  }
}
