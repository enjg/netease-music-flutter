import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import 'listentogether_controller.dart';

class ListentogetherPage extends GetView<ListentogetherController> {
  const ListentogetherPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: RadialGradient(center: Alignment(0, -0.3), radius: 0.8, colors: [Color(0xFF1a0a2e), Color(0xFF0a0a0a)])),
        child: SafeArea(child: Obx(() {
          if (controller.isMatching.value) return _buildMatching();
          if (controller.isActive.value) return _buildActive();
          return _buildHome();
        })),
      ),
    );
  }

  Widget _buildHome() {
    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child:
        Row(children: [
          IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary), onPressed: () => Get.back()),
          const Spacer(),
          const Text('一起听', style: AppTextStyles.navTitle),
          const Spacer(),
          const SizedBox(width: 48),
        ])),
      const Spacer(),
      const Text('🎧', style: TextStyle(fontSize: 80)),
      const SizedBox(height: 24),
      const Text('一起听', style: AppTextStyles.h1),
      const SizedBox(height: 12),
      const Text('找到志同道合的听歌伙伴', style: AppTextStyles.bodySmall),
      const Spacer(),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child:
        ElevatedButton(onPressed: controller.startMatch, child: const Text('开始匹配'))),
      const SizedBox(height: 80),
    ]);
  }

  Widget _buildMatching() {
    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child:
        Row(children: [
          IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary), onPressed: () { controller.cancelMatch(); Get.back(); }),
          const Spacer(),
          const Text('一起听', style: AppTextStyles.navTitle),
          const Spacer(),
          const SizedBox(width: 48),
        ])),
      const Spacer(),
      // 匹配动画
      SizedBox(width: 160, height: 160, child: Stack(children: [
        _ripple(160, 0), _ripple(160, 500), _ripple(160, 1000),
        const Center(child: Text('🎧', style: TextStyle(fontSize: 48))),
      ])),
      const SizedBox(height: 32),
      const Text('正在匹配中...', style: AppTextStyles.h3),
      const SizedBox(height: 8),
      const Text('为你寻找志同道合的听歌伙伴\n请耐心等待', style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
      const Spacer(),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child:
        OutlinedButton(onPressed: () { controller.cancelMatch(); Get.back(); },
          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.glassBorder), minimumSize: const Size(double.infinity, 48)),
          child: const Text('取消匹配', style: TextStyle(color: AppColors.textSecondary)))),
      const SizedBox(height: 80),
    ]);
  }

  Widget _ripple(double size, int delay) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.8, end: 1.5),
      duration: const Duration(seconds: 2),
      builder: (_, double scale, __) => Transform.scale(
        scale: scale,
        child: Container(
          width: size, height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2)),
        ),
      ),
    );
  }

  Widget _buildActive() {
    return Column(children: [
      Padding(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8), child:
        Row(children: [
          IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary), onPressed: () { controller.endSession(); Get.back(); }),
          const Spacer(),
          const Text('一起听中', style: AppTextStyles.navTitle),
          const Spacer(),
          const SizedBox(width: 48),
        ])),
      // 用户头像
      Padding(padding: const EdgeInsets.symmetric(vertical: 24), child:
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(children: [
            CircleAvatar(radius: 36, backgroundColor: AppColors.surface, child: const Text('😊', style: TextStyle(fontSize: 28))),
            const SizedBox(height: 8),
            const Text('我', style: AppTextStyles.caption),
          ]),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 32), child: Text('❤️', style: TextStyle(fontSize: 24))),
          Column(children: [
            CircleAvatar(radius: 36, backgroundColor: AppColors.surface, child: const Text('🎵', style: TextStyle(fontSize: 28))),
            const SizedBox(height: 8),
            const Text('对方', style: AppTextStyles.caption),
          ]),
        ])),
      const Spacer(),
      // 封面
      ClipRRect(borderRadius: BorderRadius.circular(24), child:
        Container(width: 240, height: 240, color: AppColors.surface,
          child: const Center(child: Icon(Icons.music_note, size: 80, color: AppColors.textTertiary)))),
      const Spacer(),
      const Text('晴天', style: AppTextStyles.h2),
      const SizedBox(height: 8),
      const Text('周杰伦', style: AppTextStyles.bodySmall),
      const SizedBox(height: 24),
      // 控制
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        IconButton(icon: const Icon(Icons.skip_previous_rounded, color: AppColors.textSecondary, size: 32), onPressed: () => Get.showSnackbar(GetSnackBar(message: '一起听暂不支持上一首', duration: const Duration(seconds: 1), backgroundColor: const Color(0xE6222222), margin: const EdgeInsets.all(16), borderRadius: 12))),
        const SizedBox(width: 32),
        Container(width: 64, height: 64, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: const Icon(Icons.pause_rounded, size: 36, color: AppColors.background)),
        const SizedBox(width: 32),
        IconButton(icon: const Icon(Icons.skip_next_rounded, color: AppColors.textSecondary, size: 32), onPressed: controller.toggleSong),
      ]),
      const Spacer(),
      // 底部
      Padding(padding: const EdgeInsets.symmetric(horizontal: 40), child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _bottomAction(Icons.favorite_border_rounded, '喜欢'),
          _bottomAction(Icons.share_outlined, '分享'),
          _bottomAction(Icons.close_rounded, '退出', () { controller.endSession(); Get.back(); }),
        ])),
      // 聊天
      Padding(padding: const EdgeInsets.all(16), child:
        Row(children: [
          Expanded(child: Container(height: 40, padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            alignment: Alignment.centerLeft,
            child: const Text('发送消息...', style: TextStyle(fontSize: 13, color: AppColors.textTertiary)))),
          const SizedBox(width: 10),
          const Icon(Icons.send_rounded, color: AppColors.accent, size: 22),
        ])),
      SizedBox(height: MediaQuery.of(Get.context!).padding.bottom + 8),
    ]);
  }

  Widget _bottomAction(IconData icon, String label, [VoidCallback? onTap]) => GestureDetector(
    onTap: onTap,
    child: Column(children: [
      Icon(icon, size: 24, color: AppColors.textTertiary),
      const SizedBox(height: 4),
      Text(label, style: AppTextStyles.caption),
    ]),
  );
}
