import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/widgets/skeleton.dart';
import '../../config/theme/app_text_styles.dart';
import 'charts_controller.dart';

class ChartsPage extends GetView<ChartsController> {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('排行榜'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refreshAll(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const ChartSkeleton();
        }
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => controller.refreshAll(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 官方榜
                _sectionTitle('官方榜'),
                ...controller.officialCharts.map((c) => _chartCard(c)),

                // 全球榜
                const SizedBox(height: 20),
                _sectionTitle('全球榜'),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: controller.globalCharts.map((c) => _chartGridItem(c)).toList(),
                ),

                // 新歌速递
                if (controller.topSongs.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('新歌速递'),
                  _songTypeFilter(),
                  const SizedBox(height: 8),
                  ...controller.topSongs.asMap().entries.map((e) => _songItem(e.key, e.value)),
                ],

                // 热门歌手
                if (controller.topArtists.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('热门歌手'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.topArtists.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => _artistItem(controller.topArtists[i]),
                    ),
                  ),
                ],

                // 新碟上架
                if (controller.topAlbums.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('新碟上架'),
                  _albumAreaFilter(),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.topAlbums.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => _albumItem(controller.topAlbums[i]),
                    ),
                  ),
                ],

                // MV 排行榜
                if (controller.topMvs.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _sectionTitle('MV 排行榜'),
                  _mvAreaFilter(),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.topMvs.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) => _mvItem(controller.topMvs[i]),
                    ),
                  ),
                ],

                const SizedBox(height: 200),
              ],
            ),
          ),
        );
      }),
    );
  }

  // ========== 标题 ==========

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: AppTextStyles.h3),
    );
  }

  // ========== 榜单卡片 ==========

  Widget _chartCard(Map c) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.glass,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.glassBorder, width: 0.5),
    ),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 56,
            height: 56,
            color: AppColors.surface,
            child: Image.network(
              '${c['coverImgUrl'] ?? ''}?param=112x112',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.leaderboard, color: AppColors.textTertiary),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(c['name'] ?? '', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 3),
              Text(c['updateFrequency'] ?? '', style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _chartGridItem(Map c) => Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: double.infinity,
          color: AppColors.surface,
          child: Image.network(
            '${c['coverImgUrl'] ?? ''}?param=240x240',
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.leaderboard, color: AppColors.textTertiary)),
          ),
        ),
      ),
      const SizedBox(height: 6),
      Text(c['name'] ?? '', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
    ],
  );

  // ========== 歌曲列表 ==========

  Widget _songTypeFilter() {
    final types = [
      {'label': '全部', 'value': 0},
      {'label': '华语', 'value': 7},
      {'label': '欧美', 'value': 96},
      {'label': '日本', 'value': 8},
      {'label': '韩国', 'value': 16},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: types.map((t) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(t['label'] as String),
            selected: controller.songType.value == t['value'],
            selectedColor: AppColors.accent,
            onSelected: (_) => controller.changeSongType(t['value'] as int),
          ),
        )).toList(),
      ),
    );
  }

  Widget _songItem(int i, Map s) {
    final artists = (s['artists'] ?? s['ar'] ?? []).map((a) => a['name']).join('/');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${i + 1}',
              style: TextStyle(
                fontSize: 15,
                fontWeight: i < 3 ? FontWeight.w700 : FontWeight.w500,
                color: i < 3 ? AppColors.accent : AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['name'] ?? '', style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(artists, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========== 热门歌手 ==========

  Widget _artistItem(Map a) => SizedBox(
    width: 80,
    child: Column(
      children: [
        ClipOval(
          child: Container(
            width: 64,
            height: 64,
            color: AppColors.surface,
            child: Image.network(
              '${a['picUrl'] ?? ''}?param=128x128',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.textTertiary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          a['name'] ?? '',
          style: AppTextStyles.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );

  // ========== 新碟上架 ==========

  Widget _albumAreaFilter() {
    final areas = [
      {'label': '全部', 'value': 0},
      {'label': '华语', 'value': 7},
      {'label': '欧美', 'value': 96},
      {'label': '日本', 'value': 8},
      {'label': '韩国', 'value': 16},
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: areas.map((a) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(a['label'] as String),
            selected: controller.albumArea.value == a['value'],
            selectedColor: AppColors.accent,
            onSelected: (_) => controller.changeAlbumArea(a['value'] as int),
          ),
        )).toList(),
      ),
    );
  }

  Widget _albumItem(Map a) => SizedBox(
    width: 130,
    child: Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 130,
            height: 130,
            color: AppColors.surface,
            child: Image.network(
              '${a['picUrl'] ?? ''}?param=260x260',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.album, color: AppColors.textTertiary),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          a['name'] ?? '',
          style: AppTextStyles.caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          (a['artists'] ?? []).map((ar) => ar['name']).join('/'),
          style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );

  // ========== MV 排行榜 ==========

  Widget _mvAreaFilter() {
    final areas = ['内地', '港台', '欧美', '日本', '韩国'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: areas.map((a) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(a),
            selected: controller.mvArea.value == a,
            selectedColor: AppColors.accent,
            onSelected: (_) => controller.changeMvArea(a),
          ),
        )).toList(),
      ),
    );
  }

  Widget _mvItem(Map mv) => SizedBox(
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
                  errorBuilder: (_, __, ___) => const Icon(Icons.music_video, color: AppColors.textTertiary),
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
  );
}
