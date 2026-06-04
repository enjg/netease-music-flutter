import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'live_controller.dart';

class LivePage extends GetView<LiveController> {
  const LivePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('直播电台')),
      body: Column(children: [
        // 分类
        Obx(() => SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _catChip('all', '推荐'), _catChip('music', '音乐'), _catChip('radio', '电台'),
              _catChip('talk', '情感'), _catChip('fun', '脱口秀'),
            ],
          ),
        )),
        // 列表
        Expanded(child: Obx(() {
          if (controller.isLoading.value) return const Center(child: CircularProgressIndicator(color: AppColors.accent));
          final filtered = controller.currentCat.value == 'all'
              ? controller.channels
              : controller.channels.where((c) => (c['name'] ?? '').contains(_catMap[controller.currentCat.value] ?? '')).toList();
          if (filtered.isEmpty) return const Center(child: Text('暂无直播', style: TextStyle(color: AppColors.textTertiary)));
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 1.3),
            itemCount: filtered.length,
            itemBuilder: (_, i) => _liveCard(filtered[i]),
          );
        })),
      ]),
    );
  }

  static const _catMap = {'music': '音乐', 'radio': '电台', 'talk': '情感', 'fun': '脱口秀'};

  Widget _catChip(String key, String label) {
    final active = controller.currentCat.value == key;
    return GestureDetector(
      onTap: () => controller.switchCat(key),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? AppColors.accentLight : AppColors.glass,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.accent.withOpacity(0.3) : AppColors.glassBorder, width: 0.5),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, color: active ? AppColors.accent : AppColors.textSecondary)),
      ),
    );
  }

  Widget _liveCard(Map c) {
    return Container(
      decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Expanded(child: Stack(fit: StackFit.expand, children: [
          c['coverUrl'] != null
              ? Image.network('${c['coverUrl']}?param=400x250', fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: AppColors.surface, child: const Center(child: Icon(Icons.live_tv, color: AppColors.textTertiary, size: 36))))
              : Container(color: AppColors.surface, child: const Center(child: Icon(Icons.live_tv, color: AppColors.textTertiary, size: 36))),
          Positioned(top: 8, left: 8, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(6)),
            child: const Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(Icons.circle, size: 6, color: Colors.white), SizedBox(width: 3),
              Text('直播', style: TextStyle(fontSize: 10, color: Colors.white)),
            ]),
          )),
          Positioned(bottom: 6, right: 6, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(6)),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.visibility, size: 10, color: Colors.white),
              Text(Formatters.playCount(c['score'] ?? 0), style: const TextStyle(fontSize: 10, color: Colors.white)),
            ]),
          )),
        ])),
        Padding(padding: const EdgeInsets.all(8), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(c['name'] ?? '', style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(c['regionName'] ?? '', style: AppTextStyles.caption),
        ])),
      ]),
    );
  }
}
