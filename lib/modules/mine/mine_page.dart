import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'mine_controller.dart';

class MinePage extends GetView<MineController> {
  const MinePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        final user = controller.authService.user.value;
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 0),
            child: const Text('我的', style: AppTextStyles.h1),
          )),
          // 用户卡片
          SliverToBoxAdapter(child: GestureDetector(
            onTap: () => Get.toNamed('/account'),
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.glass,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.glassBorder, width: 0.5),
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.surface,
                  backgroundImage: user.avatarUrl.isNotEmpty ? NetworkImage('${user.avatarUrl}?param=112x112') : null,
                  child: user.avatarUrl.isEmpty ? const Icon(Icons.person, size: 28, color: AppColors.textTertiary) : null,
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text(user.nickname.isEmpty ? '未登录' : user.nickname, style: AppTextStyles.h3),
                    if (user.isVip) ...[
                      const SizedBox(width: 6),
                      Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
                        child: const Text('VIP', style: TextStyle(fontSize: 10, color: Colors.white))),
                    ],
                  ]),
                  if (user.signature.isNotEmpty)
                    Padding(padding: const EdgeInsets.only(top: 4), child:
                      Text(user.signature, style: AppTextStyles.caption, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ])),
                const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
              ]),
            ),
          )),
          // 统计
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.glass,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder, width: 0.5),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat('${user.level}', '等级'),
              _stat(Formatters.number(user.listenSongs), '听歌'),
              _stat(Formatters.number(user.follows), '关注'),
              _stat(Formatters.number(user.playlistCount), '歌单'),
            ]),
          )),
          // 功能网格
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.glass,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.glassBorder, width: 0.5),
            ),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _funcItem(Icons.access_time_rounded, '最近', () => Get.toNamed('/recent/play')),
                _funcItem(Icons.download_rounded, '下载', () => Get.showSnackbar(GetSnackBar(message: '下载管理开发中', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12))),
                _funcItem(Icons.cloud_rounded, '云盘', () => Get.showSnackbar(GetSnackBar(message: '云盘开发中', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12))),
                _funcItem(Icons.favorite_border_rounded, '收藏', () => Get.showSnackbar(GetSnackBar(message: '收藏开发中', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12))),
                _funcItem(Icons.podcasts_rounded, '播客', () => Get.toNamed('/podcast')),
                _funcItem(Icons.headphones_rounded, '一起听', () => Get.toNamed('/listentogether')),
                _funcItem(Icons.mic_rounded, '音乐人', () => Get.toNamed('/musician')),
                _funcItem(Icons.monetization_on_outlined, '云贝', () => Get.toNamed('/yunbei')),
              ],
            ),
          )),
          // 创建的歌单
          _playlistSection('创建的歌单', controller.createdPlaylists),
          // 收藏的歌单
          _playlistSection('收藏的歌单', controller.subscribedPlaylists),
          const SliverToBoxAdapter(child: SizedBox(height: 160)),
        ]);
      }),
    );
  }

  Widget _stat(String num, String label) => Column(children: [
    Text(num, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    const SizedBox(height: 2),
    Text(label, style: AppTextStyles.caption),
  ]);

  Widget _funcItem(IconData icon, String label, [VoidCallback? onTap]) => GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(
        color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, size: 20, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      Text(label, style: AppTextStyles.caption),
    ]),
  );

  Widget _playlistSection(String title, List<Map<String, dynamic>> list) {
    if (list.isEmpty) return const SliverToBoxAdapter(child: SizedBox.shrink());
    return SliverToBoxAdapter(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), child: Text(title, style: AppTextStyles.h3)),
        ...list.map((p) => GestureDetector(
          onTap: () => Get.toNamed('/playlist/detail', arguments: {'id': p['id']}),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(width: 52, height: 52, color: AppColors.surface,
                  child: Image.network('${p['coverImgUrl'] ?? ''}?param=104x104', fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(Icons.music_note, color: AppColors.textTertiary, size: 24))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['name'] ?? '', style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${p['trackCount'] ?? 0}首 · ${Formatters.playCount(p['playCount'] ?? 0)}次播放', style: AppTextStyles.caption),
              ])),
            ]),
          ),
        )),
      ],
    ));
  }
}
