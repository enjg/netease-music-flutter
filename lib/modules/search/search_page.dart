import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/widgets/skeleton.dart';
import '../../config/theme/app_text_styles.dart';
import '../../app/routes.dart';
import '../../shared/services/player_service.dart';
import '../../data/models/song_model.dart';
import 'search_controller.dart';

class SearchPage extends GetView<SearchPageController> {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Obx(() => TextField(
          autofocus: true,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          decoration: InputDecoration(
            hintText: controller.defaultKeyword.value,
            hintStyle: const TextStyle(color: AppColors.textTertiary),
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          onSubmitted: controller.search,
          onChanged: (v) => controller.keyword.value = v,
        )),
        actions: [
          TextButton(
            onPressed: () => controller.search(controller.keyword.value),
            child: const Text('搜索', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isSearching.value) {
          if (controller.isLoading.value) {
            return const SearchSkeleton();
          }
          return _buildResults();
        }
        return _buildHome();
      }),
    );
  }

  Widget _buildHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 搜索历史
          if (controller.history.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('搜索历史', style: AppTextStyles.h3),
                GestureDetector(
                  onTap: controller.clearHistory,
                  child: const Icon(Icons.delete_outline, size: 20, color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: controller.history.map((h) => GestureDetector(
                onTap: () => controller.search(h),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.glass,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.glassBorder, width: 0.5),
                  ),
                  child: Text(h, style: AppTextStyles.bodySmall),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // 热搜
          const Text('热搜榜', style: AppTextStyles.h3),
          const SizedBox(height: 12),
          ...controller.hotList.take(10).toList().asMap().entries.map((entry) {
            final item = entry.value;
            return GestureDetector(
              onTap: () => controller.search(item['searchWord'] ?? ''),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text('${entry.key + 1}',
                        style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700,
                          color: entry.key < 3 ? AppColors.accent : AppColors.textTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['searchWord'] ?? '', style: AppTextStyles.bodyMedium),
                          if (item['content']?.toString().isNotEmpty == true)
                            Text(item['content'], style: AppTextStyles.caption),
                        ],
                      ),
                    ),
                    Text('${item['score'] ?? ''}', style: AppTextStyles.caption),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (controller.searchResults.isEmpty) {
      return const Center(child: Text('暂无结果', style: TextStyle(color: AppColors.textTertiary)));
    }
    return ListView.builder(
      itemCount: controller.searchResults.length,
      itemBuilder: (_, i) {
        final song = controller.searchResults[i];
        final artists = (song['artists'] as List? ?? []).map((a) => a['name']).join('/');
        return ListTile(
          title: Text(song['name'] ?? '', style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
          subtitle: Text(artists, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          onTap: () {
            final song = SongModel.fromJson(controller.searchResults[i]);
            final player = Get.find<PlayerService>();
            final songs = controller.searchResults.map((s) => SongModel.fromJson(s)).toList();
            player.playSong(song, list: songs, index: i);
            Get.toNamed(AppRoutes.player);
          },
        );
      },
    );
  }
}
