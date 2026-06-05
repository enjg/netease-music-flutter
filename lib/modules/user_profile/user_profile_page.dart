import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import '../../shared/widgets/skeleton.dart';
import 'user_profile_controller.dart';

class UserProfilePage extends GetView<UserProfileController> {
  const UserProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) return const DetailSkeleton();
        final p = controller.profile.value;
        return CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 200, pinned: true, backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [AppColors.surface, AppColors.background]),
                ),
                child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const SizedBox(height: 30),
                  CircleAvatar(radius: 40, backgroundColor: AppColors.surface,
                    backgroundImage: (p['avatarUrl'] ?? '').isNotEmpty ? NetworkImage('${p['avatarUrl']}?param=160x160') : null,
                    child: (p['avatarUrl'] ?? '').isEmpty ? const Icon(Icons.person, size: 40, color: AppColors.textTertiary) : null),
                  const SizedBox(height: 12),
                  Text(p['nickname'] ?? '', style: AppTextStyles.h2),
                  if ((p['signature'] ?? '').isNotEmpty)
                    Padding(padding: const EdgeInsets.only(top: 4), child: Text(p['signature'], style: AppTextStyles.caption, maxLines: 1)),
                ])),
              ),
            ),
          ),
          // 统计 + 关注
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16), padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat(Formatters.number(p['follows'] ?? 0), '关注'),
              _stat(Formatters.number(p['followeds'] ?? 0), '粉丝'),
              _stat('${p['level'] ?? 0}', '等级'),
            ]),
          )),
          // 歌单
          SliverToBoxAdapter(child: Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 8), child: const Text('歌单', style: AppTextStyles.h3))),
          SliverList(delegate: SliverChildBuilderDelegate((_, i) {
            final pl = controller.playlists[i];
            return GestureDetector(
              onTap: () => Get.toNamed('/playlist/detail', arguments: {'id': pl['id']}),
              child: Padding(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(children: [
                ClipRRect(borderRadius: BorderRadius.circular(10),
                  child: Container(width: 52, height: 52, color: AppColors.surface,
                    child: Image.network('${pl['coverImgUrl'] ?? ''}?param=104x104', fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: AppColors.textTertiary, size: 24)))),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(pl['name'] ?? '', style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text('${pl['trackCount'] ?? 0}首', style: AppTextStyles.caption),
                ])),
              ])),
            );
          }, childCount: controller.playlists.length)),
          const SliverToBoxAdapter(child: SizedBox(height: 200)),
        ]);
      }),
    );
  }

  Widget _stat(String num, String label) => Column(children: [
    Text(num, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    const SizedBox(height: 2), Text(label, style: AppTextStyles.caption),
  ]);
}
