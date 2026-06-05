import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../shared/widgets/skeleton.dart';
import 'vip_controller.dart';

class VipPage extends GetView<VipController> {
  const VipPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('VIP会员')),
      body: Obx(() {
        if (controller.isLoading.value) return const ListSkeleton();
        final info = controller.vipInfo.value;
        return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
          // VIP卡片
          Container(width: double.infinity, padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0x30F5A623), Color(0x20EC4141)]),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x33F5A623)),
            ),
            child: Column(children: [
              const Text('👑', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('VIP Lv.${info['redVipLevel'] ?? 0}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFFF5A623))),
              const SizedBox(height: 8),
              const Text('享受高品质音乐和专属特权', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ]),
          ),
          const SizedBox(height: 24),
          // 特权列表
          ..._privileges.map((p) => Container(
            margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Row(children: [
              Text(p['icon']!, style: const TextStyle(fontSize: 28)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(p['title']!, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
                Text(p['desc']!, style: AppTextStyles.caption),
              ])),
            ]),
          )),
          const SizedBox(height: 200),
        ]));
      }),
    );
  }

  static const _privileges = [
    {'icon': '🎵', 'title': '高品质音质', 'desc': '畅享无损音质体验'},
    {'icon': '📥', 'title': '免费下载', 'desc': 'VIP歌曲免费下载'},
    {'icon': '🎯', 'title': '专属推荐', 'desc': '个性化歌单推荐'},
    {'icon': '🎨', 'title': '个性皮肤', 'desc': '专属播放器皮肤'},
    {'icon': '🎫', 'title': '演出特权', 'desc': '演出票务优先购'},
  ];
}
