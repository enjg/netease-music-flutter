import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../shared/widgets/skeleton.dart';
import 'radio_controller.dart';

class RadioPage extends GetView<RadioController> {
  const RadioPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('电台')),
      body: Obx(() {
        if (controller.isLoading.value) return const GridSkeleton();
        return RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => controller.refresh(),
          child: CustomScrollView(slivers: [
            // 分类标签
            SliverToBoxAdapter(child: SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.categories.length + 1,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final label = i == 0 ? '全部' : (controller.categories[i-1]['name'] ?? '');
                  final selected = controller.selectedCat.value == label;
                  return GestureDetector(
                    onTap: () => controller.changeCategory(label, typeId: i > 0 ? controller.categories[i-1]['id'] : null),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.accent : AppColors.glass,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: selected ? AppColors.accent : AppColors.glassBorder, width: 0.5),
                      ),
                      child: Text(label, style: TextStyle(fontSize: 13, color: selected ? Colors.white : AppColors.textSecondary)),
                    ),
                  );
                },
              ),
            )),
            // 电台列表
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate((_, i) {
                  final r = controller.radios[i];
                  return GestureDetector(
                    onTap: () => Get.toNamed('/dj/detail', arguments: {'id': r['id']}),
                    child: Column(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Container(width: double.infinity, height: 100, color: AppColors.surface,
                          child: Image.network('${r['picUrl'] ?? ''}?param=200x200', fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.radio, color: AppColors.textTertiary, size: 32))),
                      ),
                      const SizedBox(height: 6),
                      Text(r['name'] ?? '', style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis),
                    ]),
                  );
                }, childCount: controller.radios.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 160)),
          ]),
        );
      }),
    );
  }
}
