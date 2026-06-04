import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../app/routes.dart';
import '../../shared/services/player_service.dart';
import '../../data/models/song_model.dart';
import 'home_controller.dart';
import 'widgets/banner_widget.dart';
import 'widgets/quick_entries.dart';
import 'widgets/playlist_section.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          }
          return RefreshIndicator(
            onRefresh: controller.loadData,
            color: AppColors.accent,
            child: CustomScrollView(
              slivers: [
                // 导航栏
                SliverToBoxAdapter(child: _buildNav(context)),
                // 搜索框
                SliverToBoxAdapter(child: _buildSearchBar(context)),
                // Banner
                SliverToBoxAdapter(child: BannerWidget(banners: controller.banners)),
                // 快捷入口
                const SliverToBoxAdapter(child: QuickEntries()),
                // 推荐歌单
                SliverToBoxAdapter(child: PlaylistSection(playlists: controller.playlists)),
                // 新歌速递
                SliverToBoxAdapter(child: _buildNewSongs()),
                // 独家放送
                SliverToBoxAdapter(child: _buildPrivateContent()),
                // 推荐电台
                SliverToBoxAdapter(child: _buildDjPrograms()),
                // 底部留白
                const SliverToBoxAdapter(child: SizedBox(height: 160)),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNav(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 8),
      child: Row(
        children: [
          // 头像
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.account),
            child: Container(
              width: 34, height: 34,
              decoration: BoxDecoration(
                color: AppColors.glass,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.glassBorder, width: 0.5),
              ),
              child: const Icon(Icons.person_rounded, size: 18, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(width: 10),
          const Text('发现', style: AppTextStyles.h2),
          const Spacer(),
          // 消息
          _navButton(Icons.notifications_outlined, () => Get.toNamed(AppRoutes.messages)),
          const SizedBox(width: 10),
          // 搜索
          _navButton(Icons.search_rounded, () => Get.toNamed(AppRoutes.search)),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppColors.glass,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.glassBorder, width: 0.5),
        ),
        child: Icon(icon, size: 18, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(AppRoutes.search),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.glass,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder, width: 0.5),
        ),
        child: const Row(
          children: [
            SizedBox(width: 14),
            Icon(Icons.search_rounded, size: 16, color: AppColors.textTertiary),
            SizedBox(width: 8),
            Text('搜索音乐、歌手、歌词', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)),
          ],
        ),
      ),
    );
  }

  Widget _buildNewSongs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('新歌速递', style: AppTextStyles.h3),
        ),
        ...controller.newSongs.take(9).toList().asMap().entries.map((entry) {
          final song = entry.value;
          return _songTile(song, entry.key);
        }),
      ],
    );
  }

  Widget _songTile(SongModel song, int index) {
    return GestureDetector(
      onTap: () {
        final player = Get.find<PlayerService>();
        player.playSong(song, list: controller.newSongs, index: index);
        Get.toNamed(AppRoutes.player);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 44, height: 44, color: AppColors.surface,
                child: song.coverUrl.isNotEmpty
                    ? Image.network('${song.coverUrl}?param=88x88', fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: AppColors.textTertiary, size: 20))
                    : const Icon(Icons.music_note, color: AppColors.textTertiary, size: 20),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(song.name, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(song.artistText, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivateContent() {
    if (controller.privateContent.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Text('独家放送', style: AppTextStyles.h3),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.privateContent.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final item = controller.privateContent[i];
              return ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: 140,
                  color: AppColors.surface,
                  child: Image.network('${item['sPicUrl']}?param=280x200', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.videocam, color: AppColors.textTertiary))),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDjPrograms() {
    if (controller.djPrograms.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('推荐电台', style: AppTextStyles.h3),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.podcast),
                child: const Text('更多 ›', style: AppTextStyles.caption),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: controller.djPrograms.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (_, i) {
              final item = controller.djPrograms[i];
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 100, height: 100, color: AppColors.surface,
                      child: Image.network('${item['picUrl']}?param=200x200', fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.podcasts, color: AppColors.textTertiary))),
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    width: 100,
                    child: Text(item['name'] ?? '', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
