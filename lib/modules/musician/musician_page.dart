import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config/theme/app_colors.dart';
import '../../shared/widgets/skeleton.dart';
import '../../config/theme/app_text_styles.dart';
import '../../core/utils/formatters.dart';
import 'musician_controller.dart';

class MusicianPage extends GetView<MusicianController> {
  const MusicianPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('音乐人中心')),
      body: Obx(() {
        if (controller.isLoading.value) return const ListSkeleton();
        return SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(children: [
          // 信息卡
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0x1AEC4141), Color(0x106464FF)]),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.glassBorder, width: 0.5),
            ),
            child: Row(children: [
              Container(width: 64, height: 64, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(50)),
                child: const Text('🎤', style: TextStyle(fontSize: 28))),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('独立音乐人', style: AppTextStyles.h3),
                const SizedBox(height: 4),
                Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                  decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(4)),
                  child: const Text('Lv.1', style: TextStyle(fontSize: 10, color: Colors.white))),
              ])),
            ]),
          ),
          const SizedBox(height: 16),
          // 数据概览
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat(Formatters.number(controller.overview.value['playCount'] ?? 0), '播放量'),
              _stat(Formatters.number(controller.overview.value['fansCount'] ?? 0), '粉丝'),
              _stat(Formatters.number(controller.overview.value['commentCount'] ?? 0), '评论'),
              _stat(Formatters.number(controller.overview.value['shareCount'] ?? 0), '分享'),
            ]),
          ),
          const SizedBox(height: 16),
          // 功能网格
          Container(
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(18), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: GridView.count(crossAxisCount: 4, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
              children: [
                _func(Icons.upload_rounded, '发布'), _func(Icons.analytics_outlined, '数据'),
                _func(Icons.library_music_rounded, '我的'), _func(Icons.chat_outlined, '互动'),
                _func(Icons.account_balance_wallet_outlined, '收益'), _func(Icons.campaign_outlined, '推广'),
                _func(Icons.school_outlined, '学院'), _func(Icons.settings_outlined, '设置'),
              ]),
          ),
          const SizedBox(height: 16),
          // 今日数据
          _section('今日数据', Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.glass, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.glassBorder, width: 0.5)),
            child: Column(children: [
              _row('播放量', '${controller.todayData.value['playCount'] ?? 0}'),
              _row('新增粉丝', '${controller.todayData.value['fansCount'] ?? 0}'),
              _row('新增评论', '${controller.todayData.value['commentCount'] ?? 0}'),
            ]),
          )),
          // 云豆
          _section('云豆', Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0x1FF5A623), Color(0x14F5A623)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0x26F5A623)),
            ),
            child: Row(children: [
              const Text('🫘', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('云豆余额', style: AppTextStyles.bodyMedium),
                Text('${controller.cloudbean.value}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xFFF5A623))),
              ])),
              GestureDetector(
                onTap: controller.obtainBean,
                child: Container(height: 34, padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: const Color(0xFFF5A623), borderRadius: BorderRadius.circular(17)),
                  alignment: Alignment.center,
                  child: const Text('领取', style: TextStyle(fontSize: 13, color: Color(0xFF1A1A1A)))),
              ),
            ]),
          )),
          const SizedBox(height: 200),
        ]));
      }),
    );
  }

  Widget _stat(String n, String l) => Column(children: [
    Text(n, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
    const SizedBox(height: 2),
    Text(l, style: AppTextStyles.caption),
  ]);

  Widget _func(IconData icon, String label) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
      child: Icon(icon, size: 20, color: AppColors.textPrimary)),
    const SizedBox(height: 8),
    Text(label, style: AppTextStyles.caption),
  ]);

  Widget _section(String title, Widget child) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Padding(padding: const EdgeInsets.only(bottom: 12), child: Text(title, style: AppTextStyles.h3)),
    child,
    const SizedBox(height: 16),
  ]);

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: AppTextStyles.bodySmall),
      Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
    ]),
  );
}
